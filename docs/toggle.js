// toggle.js
document.addEventListener('DOMContentLoaded', () => {
  document.querySelectorAll('.poem-section').forEach(section => {
    const ctrl = section.querySelector('.section-controls');
    ctrl.addEventListener('click', e => {
      const button = e.target.closest('button');
      if (!button) return;
      const mode = button.dataset.mode;  // "A", "B", or "both"
      section.querySelectorAll('.app.variant').forEach(span => {
        span.classList.remove('show-both');
        if (mode === 'both') {
          span.classList.add('show-both');
        } else {
          span.setAttribute('data-variant', mode);
        }
      });
    });
  });
});
