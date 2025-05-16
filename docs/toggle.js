
function toggleApparatus(mode) {
  document.querySelectorAll('.app.variant').forEach(function(app) {
    app.querySelectorAll('.rdg').forEach(function(rdg) {
      rdg.classList.add('hidden');
    });
    if (mode === 'B') {
      app.querySelector('.rdg-B').classList.remove('hidden');
    } else if (mode === 'A') {
      app.querySelector('.rdg-A').classList.remove('hidden');
    } else {
      app.querySelectorAll('.rdg').forEach(function(rdg) {
        rdg.classList.remove('hidden');
      });
    }
  });
}
