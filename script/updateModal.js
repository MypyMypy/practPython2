(() => {
  document.addEventListener("DOMContentLoaded", () => {
    const updateModal = document.getElementById("update_modal");
    const closeButton = document.querySelector(".modal__close-button");
    const submitButton = updateModal.querySelector(".modal__submit-button");
    const updateModalOpenButtons =
      document.querySelectorAll(".update-modal-link");
    const modalTitle = updateModal.querySelector(".modal__title");
    const modalInputs = updateModal.querySelector(".modal__inputs");

    const closeModalHandler = () => {
      submitButton.href = "#";
      updateModal.classList.remove("modal--active");
      modalInputs.innerHTML = "";
    };

    const updateSubmitButtonHref = (tableName, rowId) => {
      const inputs = modalInputs.querySelectorAll("input");
      const columns = [];
      inputs.forEach((input) => {
        columns.push(`${input.name}=${encodeURIComponent(input.value)}`);
      });
      submitButton.href = `index.py?update=true&table_name=${tableName}&id=${rowId}&${columns.join(
        "&"
      )}`;
    };

    const openModalHandler = (btn) => {
      updateModal.classList.add("modal--active");
      const tableName = btn.dataset.table;
      const rowId = btn.dataset.id;
      modalTitle.textContent = `Редактирование таблицы: ${tableName}`;

      const rowCells = document.querySelectorAll(
        `td[data-id="${tableName}_${rowId}"]`
      );
      rowCells.forEach((cell) => {
        const columnName = cell.dataset.column;
        const cellValue = cell.textContent;

        const label = document.createElement("label");
        label.className = "modal__label";

        const labelText = document.createElement("span");
        labelText.textContent = columnName;

        const inputField = document.createElement("input");
        inputField.type = "text";
        inputField.name = columnName;
        inputField.value = cellValue;

        inputField.addEventListener("input", () =>
          updateSubmitButtonHref(tableName, rowId)
        );

        label.append(labelText, inputField);
        modalInputs.appendChild(label);
      });

      updateSubmitButtonHref(tableName, rowId);
    };

    Array.from(updateModalOpenButtons).forEach((btn) =>
      btn.addEventListener("click", (e) => {
        e.preventDefault();
        openModalHandler(btn);
      })
    );

    updateModal.addEventListener(
      "click",
      (e) => e.target.id === "update_modal" && closeModalHandler()
    );
    closeButton.addEventListener("click", () => closeModalHandler());
  });
})();
