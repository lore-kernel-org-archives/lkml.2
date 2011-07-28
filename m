Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402Ab1G1Pu1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 11:50:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3879 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753537Ab1G1PuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 11:50:15 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 04/40] UAPI: Convert #include "..." to #include <path/...> in
 kernel system headers [ver #3]
To: torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Date: Thu, 28 Jul 2011 16:49:59 +0100
Message-ID: <20110728154958.16618.97144.stgit@warthog.procyon.org.uk>
In-Reply-To: <20110728154920.16618.89358.stgit@warthog.procyon.org.uk>
References: <20110728154920.16618.89358.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert #include "..." to #include <path/...> in kernel system headers.

scripts/uapi-disintegrate/drm-headers.pl was used

Signed-off-by: David Howells <dhowells@redhat.com>
---

 drivers/gpu/drm/ati_pcigart.c                   |    2 +-
 drivers/gpu/drm/drm_agpsupport.c                |    2 +-
 drivers/gpu/drm/drm_auth.c                      |    2 +-
 drivers/gpu/drm/drm_buffer.c                    |    2 +-
 drivers/gpu/drm/drm_bufs.c                      |    2 +-
 drivers/gpu/drm/drm_cache.c                     |    2 +-
 drivers/gpu/drm/drm_context.c                   |    2 +-
 drivers/gpu/drm/drm_crtc.c                      |    8 ++++----
 drivers/gpu/drm/drm_crtc_helper.c               |    8 ++++----
 drivers/gpu/drm/drm_debugfs.c                   |    2 +-
 drivers/gpu/drm/drm_dma.c                       |    2 +-
 drivers/gpu/drm/drm_dp_i2c_helper.c             |    4 ++--
 drivers/gpu/drm/drm_drv.c                       |    4 ++--
 drivers/gpu/drm/drm_edid.c                      |    4 ++--
 drivers/gpu/drm/drm_edid_modes.h                |    4 ++--
 drivers/gpu/drm/drm_encoder_slave.c             |    2 +-
 drivers/gpu/drm/drm_fb_helper.c                 |    8 ++++----
 drivers/gpu/drm/drm_fops.c                      |    2 +-
 drivers/gpu/drm/drm_gem.c                       |    2 +-
 drivers/gpu/drm/drm_global.c                    |    2 +-
 drivers/gpu/drm/drm_hashtab.c                   |    4 ++--
 drivers/gpu/drm/drm_info.c                      |    2 +-
 drivers/gpu/drm/drm_ioc32.c                     |    4 ++--
 drivers/gpu/drm/drm_ioctl.c                     |    6 +++---
 drivers/gpu/drm/drm_irq.c                       |    2 +-
 drivers/gpu/drm/drm_lock.c                      |    2 +-
 drivers/gpu/drm/drm_memory.c                    |    2 +-
 drivers/gpu/drm/drm_mm.c                        |    4 ++--
 drivers/gpu/drm/drm_modes.c                     |    6 +++---
 drivers/gpu/drm/drm_pci.c                       |    2 +-
 drivers/gpu/drm/drm_platform.c                  |    2 +-
 drivers/gpu/drm/drm_proc.c                      |    2 +-
 drivers/gpu/drm/drm_scatter.c                   |    2 +-
 drivers/gpu/drm/drm_sman.c                      |    2 +-
 drivers/gpu/drm/drm_stub.c                      |    4 ++--
 drivers/gpu/drm/drm_sysfs.c                     |    6 +++---
 drivers/gpu/drm/drm_trace_points.c              |    2 +-
 drivers/gpu/drm/drm_usb.c                       |    2 +-
 drivers/gpu/drm/drm_vm.c                        |    2 +-
 drivers/gpu/drm/i2c/ch7006_priv.h               |    8 ++++----
 drivers/gpu/drm/i2c/sil164_drv.c                |    8 ++++----
 drivers/gpu/drm/i810/i810_dma.c                 |    6 +++---
 drivers/gpu/drm/i810/i810_drv.c                 |    8 ++++----
 drivers/gpu/drm/i915/dvo.h                      |    6 +++---
 drivers/gpu/drm/i915/i915_debugfs.c             |    6 +++---
 drivers/gpu/drm/i915/i915_dma.c                 |   10 +++++-----
 drivers/gpu/drm/i915/i915_drv.c                 |    8 ++++----
 drivers/gpu/drm/i915/i915_gem.c                 |    6 +++---
 drivers/gpu/drm/i915/i915_gem_debug.c           |    6 +++---
 drivers/gpu/drm/i915/i915_gem_evict.c           |    6 +++---
 drivers/gpu/drm/i915/i915_gem_execbuffer.c      |    6 +++---
 drivers/gpu/drm/i915/i915_gem_gtt.c             |    6 +++---
 drivers/gpu/drm/i915/i915_gem_tiling.c          |   10 +++++-----
 drivers/gpu/drm/i915/i915_ioc32.c               |    6 +++---
 drivers/gpu/drm/i915/i915_irq.c                 |    6 +++---
 drivers/gpu/drm/i915/i915_mem.c                 |    6 +++---
 drivers/gpu/drm/i915/i915_suspend.c             |    6 +++---
 drivers/gpu/drm/i915/intel_acpi.c               |    2 +-
 drivers/gpu/drm/i915/intel_bios.c               |    6 +++---
 drivers/gpu/drm/i915/intel_bios.h               |    2 +-
 drivers/gpu/drm/i915/intel_crt.c                |   12 ++++++------
 drivers/gpu/drm/i915/intel_display.c            |    8 ++++----
 drivers/gpu/drm/i915/intel_dp.c                 |   12 ++++++------
 drivers/gpu/drm/i915/intel_drv.h                |    6 +++---
 drivers/gpu/drm/i915/intel_dvo.c                |    8 ++++----
 drivers/gpu/drm/i915/intel_fb.c                 |   10 +++++-----
 drivers/gpu/drm/i915/intel_hdmi.c               |   10 +++++-----
 drivers/gpu/drm/i915/intel_i2c.c                |    6 +++---
 drivers/gpu/drm/i915/intel_lvds.c               |   10 +++++-----
 drivers/gpu/drm/i915/intel_modes.c              |    2 +-
 drivers/gpu/drm/i915/intel_opregion.c           |    4 ++--
 drivers/gpu/drm/i915/intel_overlay.c            |    6 +++---
 drivers/gpu/drm/i915/intel_ringbuffer.c         |    6 +++---
 drivers/gpu/drm/i915/intel_sdvo.c               |   10 +++++-----
 drivers/gpu/drm/i915/intel_tv.c                 |   10 +++++-----
 drivers/gpu/drm/mga/mga_dma.c                   |    8 ++++----
 drivers/gpu/drm/mga/mga_drv.c                   |    8 ++++----
 drivers/gpu/drm/mga/mga_ioc32.c                 |    6 +++---
 drivers/gpu/drm/mga/mga_irq.c                   |    6 +++---
 drivers/gpu/drm/mga/mga_state.c                 |    6 +++---
 drivers/gpu/drm/mga/mga_warp.c                  |    6 +++---
 drivers/gpu/drm/nouveau/nouveau_acpi.c          |   10 +++++-----
 drivers/gpu/drm/nouveau/nouveau_backlight.c     |    4 ++--
 drivers/gpu/drm/nouveau/nouveau_bios.c          |    2 +-
 drivers/gpu/drm/nouveau/nouveau_bo.c            |    4 ++--
 drivers/gpu/drm/nouveau/nouveau_calc.c          |    2 +-
 drivers/gpu/drm/nouveau/nouveau_channel.c       |    6 +++---
 drivers/gpu/drm/nouveau/nouveau_connector.c     |    6 +++---
 drivers/gpu/drm/nouveau/nouveau_connector.h     |    2 +-
 drivers/gpu/drm/nouveau/nouveau_debugfs.c       |    2 +-
 drivers/gpu/drm/nouveau/nouveau_display.c       |    4 ++--
 drivers/gpu/drm/nouveau/nouveau_dma.c           |    4 ++--
 drivers/gpu/drm/nouveau/nouveau_dp.c            |    2 +-
 drivers/gpu/drm/nouveau/nouveau_drv.c           |    8 ++++----
 drivers/gpu/drm/nouveau/nouveau_drv.h           |   12 ++++++------
 drivers/gpu/drm/nouveau/nouveau_encoder.h       |    2 +-
 drivers/gpu/drm/nouveau/nouveau_fbcon.c         |   12 ++++++------
 drivers/gpu/drm/nouveau/nouveau_fbcon.h         |    2 +-
 drivers/gpu/drm/nouveau/nouveau_fence.c         |    4 ++--
 drivers/gpu/drm/nouveau/nouveau_gem.c           |    6 +++---
 drivers/gpu/drm/nouveau/nouveau_hw.c            |    2 +-
 drivers/gpu/drm/nouveau/nouveau_hw.h            |    2 +-
 drivers/gpu/drm/nouveau/nouveau_i2c.c           |    2 +-
 drivers/gpu/drm/nouveau/nouveau_i2c.h           |    2 +-
 drivers/gpu/drm/nouveau/nouveau_ioc32.c         |    4 ++--
 drivers/gpu/drm/nouveau/nouveau_irq.c           |    6 +++---
 drivers/gpu/drm/nouveau/nouveau_mem.c           |    6 +++---
 drivers/gpu/drm/nouveau/nouveau_mm.c            |    2 +-
 drivers/gpu/drm/nouveau/nouveau_notifier.c      |    4 ++--
 drivers/gpu/drm/nouveau/nouveau_object.c        |    6 +++---
 drivers/gpu/drm/nouveau/nouveau_perf.c          |    2 +-
 drivers/gpu/drm/nouveau/nouveau_pm.c            |    2 +-
 drivers/gpu/drm/nouveau/nouveau_ramht.c         |    2 +-
 drivers/gpu/drm/nouveau/nouveau_sgdma.c         |    2 +-
 drivers/gpu/drm/nouveau/nouveau_state.c         |   10 +++++-----
 drivers/gpu/drm/nouveau/nouveau_temp.c          |    2 +-
 drivers/gpu/drm/nouveau/nouveau_ttm.c           |    2 +-
 drivers/gpu/drm/nouveau/nouveau_vm.c            |    2 +-
 drivers/gpu/drm/nouveau/nouveau_vm.h            |    2 +-
 drivers/gpu/drm/nouveau/nouveau_volt.c          |    2 +-
 drivers/gpu/drm/nouveau/nv04_crtc.c             |    4 ++--
 drivers/gpu/drm/nouveau/nv04_cursor.c           |    4 ++--
 drivers/gpu/drm/nouveau/nv04_dac.c              |    4 ++--
 drivers/gpu/drm/nouveau/nv04_dfp.c              |    6 +++---
 drivers/gpu/drm/nouveau/nv04_display.c          |    6 +++---
 drivers/gpu/drm/nouveau/nv04_fb.c               |    6 +++---
 drivers/gpu/drm/nouveau/nv04_fbcon.c            |    2 +-
 drivers/gpu/drm/nouveau/nv04_fifo.c             |    4 ++--
 drivers/gpu/drm/nouveau/nv04_graph.c            |    6 +++---
 drivers/gpu/drm/nouveau/nv04_instmem.c          |    4 ++--
 drivers/gpu/drm/nouveau/nv04_mc.c               |    6 +++---
 drivers/gpu/drm/nouveau/nv04_pm.c               |    2 +-
 drivers/gpu/drm/nouveau/nv04_timer.c            |    6 +++---
 drivers/gpu/drm/nouveau/nv04_tv.c               |    6 +++---
 drivers/gpu/drm/nouveau/nv10_fb.c               |    6 +++---
 drivers/gpu/drm/nouveau/nv10_fifo.c             |    4 ++--
 drivers/gpu/drm/nouveau/nv10_gpio.c             |    2 +-
 drivers/gpu/drm/nouveau/nv10_graph.c            |    6 +++---
 drivers/gpu/drm/nouveau/nv17_tv.c               |    4 ++--
 drivers/gpu/drm/nouveau/nv17_tv_modes.c         |    4 ++--
 drivers/gpu/drm/nouveau/nv20_graph.c            |    6 +++---
 drivers/gpu/drm/nouveau/nv30_fb.c               |    6 +++---
 drivers/gpu/drm/nouveau/nv40_fb.c               |    6 +++---
 drivers/gpu/drm/nouveau/nv40_fifo.c             |    4 ++--
 drivers/gpu/drm/nouveau/nv40_graph.c            |    4 ++--
 drivers/gpu/drm/nouveau/nv40_grctx.c            |    2 +-
 drivers/gpu/drm/nouveau/nv40_mc.c               |    6 +++---
 drivers/gpu/drm/nouveau/nv40_mpeg.c             |    2 +-
 drivers/gpu/drm/nouveau/nv50_calc.c             |    2 +-
 drivers/gpu/drm/nouveau/nv50_crtc.c             |    6 +++---
 drivers/gpu/drm/nouveau/nv50_cursor.c           |    4 ++--
 drivers/gpu/drm/nouveau/nv50_dac.c              |    4 ++--
 drivers/gpu/drm/nouveau/nv50_display.c          |    2 +-
 drivers/gpu/drm/nouveau/nv50_display.h          |    4 ++--
 drivers/gpu/drm/nouveau/nv50_evo.c              |    2 +-
 drivers/gpu/drm/nouveau/nv50_fb.c               |    6 +++---
 drivers/gpu/drm/nouveau/nv50_fbcon.c            |    2 +-
 drivers/gpu/drm/nouveau/nv50_fifo.c             |    4 ++--
 drivers/gpu/drm/nouveau/nv50_gpio.c             |    2 +-
 drivers/gpu/drm/nouveau/nv50_graph.c            |    4 ++--
 drivers/gpu/drm/nouveau/nv50_grctx.c            |    2 +-
 drivers/gpu/drm/nouveau/nv50_instmem.c          |    4 ++--
 drivers/gpu/drm/nouveau/nv50_mc.c               |    4 ++--
 drivers/gpu/drm/nouveau/nv50_mpeg.c             |    2 +-
 drivers/gpu/drm/nouveau/nv50_pm.c               |    2 +-
 drivers/gpu/drm/nouveau/nv50_sor.c              |    4 ++--
 drivers/gpu/drm/nouveau/nv50_vm.c               |    2 +-
 drivers/gpu/drm/nouveau/nv50_vram.c             |    2 +-
 drivers/gpu/drm/nouveau/nv84_crypt.c            |    2 +-
 drivers/gpu/drm/nouveau/nva3_copy.c             |    2 +-
 drivers/gpu/drm/nouveau/nva3_pm.c               |    2 +-
 drivers/gpu/drm/nouveau/nvc0_copy.c             |    2 +-
 drivers/gpu/drm/nouveau/nvc0_fb.c               |    6 +++---
 drivers/gpu/drm/nouveau/nvc0_fbcon.c            |    2 +-
 drivers/gpu/drm/nouveau/nvc0_fifo.c             |    2 +-
 drivers/gpu/drm/nouveau/nvc0_graph.c            |    2 +-
 drivers/gpu/drm/nouveau/nvc0_grctx.c            |    2 +-
 drivers/gpu/drm/nouveau/nvc0_instmem.c          |    2 +-
 drivers/gpu/drm/nouveau/nvc0_vm.c               |    2 +-
 drivers/gpu/drm/nouveau/nvc0_vram.c             |    2 +-
 drivers/gpu/drm/r128/r128_cce.c                 |    6 +++---
 drivers/gpu/drm/r128/r128_drv.c                 |    8 ++++----
 drivers/gpu/drm/r128/r128_ioc32.c               |    6 +++---
 drivers/gpu/drm/r128/r128_irq.c                 |    6 +++---
 drivers/gpu/drm/r128/r128_state.c               |    6 +++---
 drivers/gpu/drm/radeon/atom.h                   |    2 +-
 drivers/gpu/drm/radeon/atombios_dp.c            |    6 +++---
 drivers/gpu/drm/radeon/evergreen.c              |    4 ++--
 drivers/gpu/drm/radeon/evergreen_blit_kms.c     |    6 +++---
 drivers/gpu/drm/radeon/evergreen_cs.c           |    2 +-
 drivers/gpu/drm/radeon/ni.c                     |    4 ++--
 drivers/gpu/drm/radeon/r100.c                   |    6 +++---
 drivers/gpu/drm/radeon/r200.c                   |    6 +++---
 drivers/gpu/drm/radeon/r300.c                   |    2 +-
 drivers/gpu/drm/radeon/r300_cmdbuf.c            |    8 ++++----
 drivers/gpu/drm/radeon/r420.c                   |    2 +-
 drivers/gpu/drm/radeon/r520.c                   |    2 +-
 drivers/gpu/drm/radeon/r600.c                   |    4 ++--
 drivers/gpu/drm/radeon/r600_audio.c             |    2 +-
 drivers/gpu/drm/radeon/r600_blit.c              |    6 +++---
 drivers/gpu/drm/radeon/r600_blit_kms.c          |    6 +++---
 drivers/gpu/drm/radeon/r600_cp.c                |    6 +++---
 drivers/gpu/drm/radeon/r600_cs.c                |    2 +-
 drivers/gpu/drm/radeon/r600_hdmi.c              |    4 ++--
 drivers/gpu/drm/radeon/radeon_acpi.c            |    8 ++++----
 drivers/gpu/drm/radeon/radeon_agp.c             |    6 +++---
 drivers/gpu/drm/radeon/radeon_atombios.c        |    4 ++--
 drivers/gpu/drm/radeon/radeon_bios.c            |    2 +-
 drivers/gpu/drm/radeon/radeon_clocks.c          |    4 ++--
 drivers/gpu/drm/radeon/radeon_combios.c         |    4 ++--
 drivers/gpu/drm/radeon/radeon_connectors.c      |   10 +++++-----
 drivers/gpu/drm/radeon/radeon_cp.c              |    8 ++++----
 drivers/gpu/drm/radeon/radeon_cs.c              |    4 ++--
 drivers/gpu/drm/radeon/radeon_cursor.c          |    4 ++--
 drivers/gpu/drm/radeon/radeon_display.c         |    8 ++++----
 drivers/gpu/drm/radeon/radeon_drv.c             |    8 ++++----
 drivers/gpu/drm/radeon/radeon_encoders.c        |    6 +++---
 drivers/gpu/drm/radeon/radeon_fb.c              |   12 ++++++------
 drivers/gpu/drm/radeon/radeon_fence.c           |    4 ++--
 drivers/gpu/drm/radeon/radeon_gart.c            |    4 ++--
 drivers/gpu/drm/radeon/radeon_gem.c             |    6 +++---
 drivers/gpu/drm/radeon/radeon_i2c.c             |    4 ++--
 drivers/gpu/drm/radeon/radeon_ioc32.c           |    6 +++---
 drivers/gpu/drm/radeon/radeon_irq.c             |    6 +++---
 drivers/gpu/drm/radeon/radeon_irq_kms.c         |    6 +++---
 drivers/gpu/drm/radeon/radeon_kms.c             |    6 +++---
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c |    6 +++---
 drivers/gpu/drm/radeon/radeon_legacy_tv.c       |    4 ++--
 drivers/gpu/drm/radeon/radeon_mem.c             |    6 +++---
 drivers/gpu/drm/radeon/radeon_object.c          |    2 +-
 drivers/gpu/drm/radeon/radeon_pm.c              |    2 +-
 drivers/gpu/drm/radeon/radeon_ring.c            |    4 ++--
 drivers/gpu/drm/radeon/radeon_state.c           |   10 +++++-----
 drivers/gpu/drm/radeon/radeon_trace_points.c    |    2 +-
 drivers/gpu/drm/radeon/rs600.c                  |    2 +-
 drivers/gpu/drm/radeon/rs690.c                  |    2 +-
 drivers/gpu/drm/radeon/rv515.c                  |    2 +-
 drivers/gpu/drm/radeon/rv770.c                  |    4 ++--
 drivers/gpu/drm/savage/savage_bci.c             |    4 ++--
 drivers/gpu/drm/savage/savage_drv.c             |    6 +++---
 drivers/gpu/drm/savage/savage_state.c           |    4 ++--
 drivers/gpu/drm/sis/sis_drv.c                   |    6 +++---
 drivers/gpu/drm/sis/sis_drv.h                   |    2 +-
 drivers/gpu/drm/sis/sis_mm.c                    |    4 ++--
 drivers/gpu/drm/tdfx/tdfx_drv.c                 |    4 ++--
 drivers/gpu/drm/ttm/ttm_agp_backend.c           |    6 +++---
 drivers/gpu/drm/ttm/ttm_bo.c                    |    6 +++---
 drivers/gpu/drm/ttm/ttm_bo_manager.c            |    8 ++++----
 drivers/gpu/drm/ttm/ttm_bo_util.c               |    4 ++--
 drivers/gpu/drm/ttm/ttm_execbuf_util.c          |    6 +++---
 drivers/gpu/drm/ttm/ttm_lock.c                  |    4 ++--
 drivers/gpu/drm/ttm/ttm_memory.c                |    6 +++---
 drivers/gpu/drm/ttm/ttm_module.c                |    4 ++--
 drivers/gpu/drm/ttm/ttm_object.c                |    4 ++--
 drivers/gpu/drm/ttm/ttm_page_alloc.c            |    4 ++--
 drivers/gpu/drm/ttm/ttm_tt.c                    |   12 ++++++------
 drivers/gpu/drm/via/via_dma.c                   |    6 +++---
 drivers/gpu/drm/via/via_dmablit.c               |    4 ++--
 drivers/gpu/drm/via/via_drv.c                   |    6 +++---
 drivers/gpu/drm/via/via_drv.h                   |    2 +-
 drivers/gpu/drm/via/via_irq.c                   |    6 +++---
 drivers/gpu/drm/via/via_map.c                   |    4 ++--
 drivers/gpu/drm/via/via_mm.c                    |    6 +++---
 drivers/gpu/drm/via/via_verifier.c              |    6 +++---
 drivers/gpu/drm/via/via_video.c                 |    4 ++--
 drivers/gpu/drm/vmwgfx/vmwgfx_buffer.c          |    4 ++--
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c             |   10 +++++-----
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h             |   18 +++++++++---------
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c         |    4 ++--
 drivers/gpu/drm/vmwgfx/vmwgfx_fb.c              |    4 ++--
 drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c            |    4 ++--
 drivers/gpu/drm/vmwgfx/vmwgfx_gmr.c             |    4 ++--
 drivers/gpu/drm/vmwgfx/vmwgfx_gmrid_manager.c   |    6 +++---
 drivers/gpu/drm/vmwgfx/vmwgfx_ioctl.c           |    2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_irq.c             |    2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.h             |    2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c         |    4 ++--
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c        |    8 ++++----
 drivers/gpu/drm/vmwgfx/vmwgfx_ttm_glue.c        |    2 +-
 279 files changed, 648 insertions(+), 648 deletions(-)

diff --git a/drivers/gpu/drm/ati_pcigart.c b/drivers/gpu/drm/ati_pcigart.c
index 1c36492..d2c6b78 100644
--- a/drivers/gpu/drm/ati_pcigart.c
+++ b/drivers/gpu/drm/ati_pcigart.c
@@ -31,7 +31,7 @@
  * DEALINGS IN THE SOFTWARE.
  */
 
-#include "drmP.h"
+#include <drm/drmP.h>
 
 # define ATI_PCIGART_PAGE_SIZE		4096	/**< PCI GART page size */
 
diff --git a/drivers/gpu/drm/drm_agpsupport.c b/drivers/gpu/drm/drm_agpsupport.c
index 0cb2ba5..3d8fed1 100644
--- a/drivers/gpu/drm/drm_agpsupport.c
+++ b/drivers/gpu/drm/drm_agpsupport.c
@@ -31,7 +31,7 @@
  * OTHER DEALINGS IN THE SOFTWARE.
  */
 
-#include "drmP.h"
+#include <drm/drmP.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 
diff --git a/drivers/gpu/drm/drm_auth.c b/drivers/gpu/drm/drm_auth.c
index 3f46772..7e83cc4 100644
--- a/drivers/gpu/drm/drm_auth.c
+++ b/drivers/gpu/drm/drm_auth.c
@@ -33,7 +33,7 @@
  * OTHER DEALINGS IN THE SOFTWARE.
  */
 
-#include "drmP.h"
+#include <drm/drmP.h>
 
 /**
  * Find the file with the given magic number.
diff --git a/drivers/gpu/drm/drm_buffer.c b/drivers/gpu/drm/drm_buffer.c
index 529a0db..bc5def7 100644
--- a/drivers/gpu/drm/drm_buffer.c
+++ b/drivers/gpu/drm/drm_buffer.c
@@ -32,7 +32,7 @@
  * Pauli Nieminen <suokkos-at-gmail-dot-com>
  */
 
-#include "drm_buffer.h"
+#include <drm/drm_buffer.h>
 
 /**
  * Allocate the drm buffer object.
diff --git a/drivers/gpu/drm/drm_bufs.c b/drivers/gpu/drm/drm_bufs.c
index 61e1ef9..a69786c 100644
--- a/drivers/gpu/drm/drm_bufs.c
+++ b/drivers/gpu/drm/drm_bufs.c
@@ -37,7 +37,7 @@
 #include <linux/slab.h>
 #include <linux/log2.h>
 #include <asm/shmparam.h>
-#include "drmP.h"
+#include <drm/drmP.h>
 
 static struct drm_map_list *drm_find_matching_map(struct drm_device *dev,
 						  struct drm_local_map *map)
diff --git a/drivers/gpu/drm/drm_cache.c b/drivers/gpu/drm/drm_cache.c
index 0e3bd5b..74c711a 100644
--- a/drivers/gpu/drm/drm_cache.c
+++ b/drivers/gpu/drm/drm_cache.c
@@ -28,7 +28,7 @@
  * Authors: Thomas Hellström <thomas-at-tungstengraphics-dot-com>
  */
 
-#include "drmP.h"
+#include <drm/drmP.h>
 
 #if defined(CONFIG_X86)
 static void
diff --git a/drivers/gpu/drm/drm_context.c b/drivers/gpu/drm/drm_context.c
index 6d440fb..8c2474c 100644
--- a/drivers/gpu/drm/drm_context.c
+++ b/drivers/gpu/drm/drm_context.c
@@ -40,7 +40,7 @@
  *		needed by SiS driver's memory management.
  */
 
-#include "drmP.h"
+#include <drm/drmP.h>
 
 /******************************************************************/
 /** \name Context bitmap support */
diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
index 82db185..a9b78a7 100644
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -31,10 +31,10 @@
  */
 #include <linux/list.h>
 #include <linux/slab.h>
-#include "drm.h"
-#include "drmP.h"
-#include "drm_crtc.h"
-#include "drm_edid.h"
+#include <drm/drm.h>
+#include <drm/drmP.h>
+#include <drm/drm_crtc.h>
+#include <drm/drm_edid.h>
 
 struct drm_prop_enum_list {
 	int type;
diff --git a/drivers/gpu/drm/drm_crtc_helper.c b/drivers/gpu/drm/drm_crtc_helper.c
index f88a9b2..006e606 100644
--- a/drivers/gpu/drm/drm_crtc_helper.c
+++ b/drivers/gpu/drm/drm_crtc_helper.c
@@ -29,10 +29,10 @@
  *      Jesse Barnes <jesse.barnes@intel.com>
  */
 
-#include "drmP.h"
-#include "drm_crtc.h"
-#include "drm_crtc_helper.h"
-#include "drm_fb_helper.h"
+#include <drm/drmP.h>
+#include <drm/drm_crtc.h>
+#include <drm/drm_crtc_helper.h>
+#include <drm/drm_fb_helper.h>
 
 static bool drm_kms_helper_poll = true;
 module_param_named(poll, drm_kms_helper_poll, bool, 0600);
diff --git a/drivers/gpu/drm/drm_debugfs.c b/drivers/gpu/drm/drm_debugfs.c
index 9d8c892..f736178 100644
--- a/drivers/gpu/drm/drm_debugfs.c
+++ b/drivers/gpu/drm/drm_debugfs.c
@@ -33,7 +33,7 @@
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
-#include "drmP.h"
+#include <drm/drmP.h>
 
 #if defined(CONFIG_DEBUG_FS)
 
diff --git a/drivers/gpu/drm/drm_dma.c b/drivers/gpu/drm/drm_dma.c
index 252cbd7..9764b07 100644
--- a/drivers/gpu/drm/drm_dma.c
+++ b/drivers/gpu/drm/drm_dma.c
@@ -33,7 +33,7 @@
  * OTHER DEALINGS IN THE SOFTWARE.
  */
 
-#include "drmP.h"
+#include <drm/drmP.h>
 
 /**
  * Initialize the DMA data.
diff --git a/drivers/gpu/drm/drm_dp_i2c_helper.c b/drivers/gpu/drm/drm_dp_i2c_helper.c
index f7eba0a..7f246f2 100644
--- a/drivers/gpu/drm/drm_dp_i2c_helper.c
+++ b/drivers/gpu/drm/drm_dp_i2c_helper.c
@@ -27,8 +27,8 @@
 #include <linux/errno.h>
 #include <linux/sched.h>
 #include <linux/i2c.h>
-#include "drm_dp_helper.h"
-#include "drmP.h"
+#include <drm/drm_dp_helper.h>
+#include <drm/drmP.h>
 
 /* Run a single AUX_CH I2C transaction, writing/reading data as necessary */
 static int
diff --git a/drivers/gpu/drm/drm_drv.c b/drivers/gpu/drm/drm_drv.c
index 93a112d..4df5805 100644
--- a/drivers/gpu/drm/drm_drv.c
+++ b/drivers/gpu/drm/drm_drv.c
@@ -48,8 +48,8 @@
 
 #include <linux/debugfs.h>
 #include <linux/slab.h>
-#include "drmP.h"
-#include "drm_core.h"
+#include <drm/drmP.h>
+#include <drm/drm_core.h>
 
 
 static int drm_version(struct drm_device *dev, void *data,
diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index 756af4d..8e0f3a0 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -30,8 +30,8 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
-#include "drmP.h"
-#include "drm_edid.h"
+#include <drm/drmP.h>
+#include <drm/drm_edid.h>
 #include "drm_edid_modes.h"
 
 #define version_greater(edid, maj, min) \
diff --git a/drivers/gpu/drm/drm_edid_modes.h b/drivers/gpu/drm/drm_edid_modes.h
index 5f20644..f84acdc 100644
--- a/drivers/gpu/drm/drm_edid_modes.h
+++ b/drivers/gpu/drm/drm_edid_modes.h
@@ -24,8 +24,8 @@
  */
 
 #include <linux/kernel.h>
-#include "drmP.h"
-#include "drm_edid.h"
+#include <drm/drmP.h>
+#include <drm/drm_edid.h>
 
 /*
  * Autogenerated from the DMT spec.
diff --git a/drivers/gpu/drm/drm_encoder_slave.c b/drivers/gpu/drm/drm_encoder_slave.c
index d62c064..2fc7bbb 100644
--- a/drivers/gpu/drm/drm_encoder_slave.c
+++ b/drivers/gpu/drm/drm_encoder_slave.c
@@ -24,7 +24,7 @@
  *
  */
 
-#include "drm_encoder_slave.h"
+#include <drm/drm_encoder_slave.h>
 
 /**
  * drm_i2c_encoder_init - Initialize an I2C slave encoder
diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index 802b61a..bcfba54 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -31,10 +31,10 @@
 #include <linux/sysrq.h>
 #include <linux/slab.h>
 #include <linux/fb.h>
-#include "drmP.h"
-#include "drm_crtc.h"
-#include "drm_fb_helper.h"
-#include "drm_crtc_helper.h"
+#include <drm/drmP.h>
+#include <drm/drm_crtc.h>
+#include <drm/drm_fb_helper.h>
+#include <drm/drm_crtc_helper.h>
 
 MODULE_AUTHOR("David Airlie, Jesse Barnes");
 MODULE_DESCRIPTION("DRM KMS helper");
diff --git a/drivers/gpu/drm/drm_fops.c b/drivers/gpu/drm/drm_fops.c
index 2ec7d48..c419aa1 100644
--- a/drivers/gpu/drm/drm_fops.c
+++ b/drivers/gpu/drm/drm_fops.c
@@ -34,7 +34,7 @@
  * OTHER DEALINGS IN THE SOFTWARE.
  */
 
-#include "drmP.h"
+#include <drm/drmP.h>
 #include <linux/poll.h>
 #include <linux/slab.h>
 
diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
index 186d62e..dc4ac02 100644
--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -35,7 +35,7 @@
 #include <linux/mman.h>
 #include <linux/pagemap.h>
 #include <linux/shmem_fs.h>
-#include "drmP.h"
+#include <drm/drmP.h>
 
 /** @file drm_gem.c
  *
diff --git a/drivers/gpu/drm/drm_global.c b/drivers/gpu/drm/drm_global.c
index c87dc96..f731116 100644
--- a/drivers/gpu/drm/drm_global.c
+++ b/drivers/gpu/drm/drm_global.c
@@ -31,7 +31,7 @@
 #include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/module.h>
-#include "drm_global.h"
+#include <drm/drm_global.h>
 
 struct drm_global_item {
 	struct mutex mutex;
diff --git a/drivers/gpu/drm/drm_hashtab.c b/drivers/gpu/drm/drm_hashtab.c
index e3a7568..9d4cfa1 100644
--- a/drivers/gpu/drm/drm_hashtab.c
+++ b/drivers/gpu/drm/drm_hashtab.c
@@ -32,8 +32,8 @@
  * Thomas Hellström <thomas-at-tungstengraphics-dot-com>
  */
 
-#include "drmP.h"
-#include "drm_hashtab.h"
+#include <drm/drmP.h>
+#include <drm/drm_hashtab.h>
 #include <linux/hash.h>
 #include <linux/slab.h>
 
diff --git a/drivers/gpu/drm/drm_info.c b/drivers/gpu/drm/drm_info.c
index ab1162d..50afc9e 100644
--- a/drivers/gpu/drm/drm_info.c
+++ b/drivers/gpu/drm/drm_info.c
@@ -34,7 +34,7 @@
  */
 
 #include <linux/seq_file.h>
-#include "drmP.h"
+#include <drm/drmP.h>
 
 /**
  * Called when "/proc/dri/.../name" is read.
diff --git a/drivers/gpu/drm/drm_ioc32.c b/drivers/gpu/drm/drm_ioc32.c
index 4a058c7..f32ebdf 100644
--- a/drivers/gpu/drm/drm_ioc32.c
+++ b/drivers/gpu/drm/drm_ioc32.c
@@ -30,8 +30,8 @@
 #include <linux/compat.h>
 #include <linux/ratelimit.h>
 
-#include "drmP.h"
-#include "drm_core.h"
+#include <drm/drmP.h>
+#include <drm/drm_core.h>
 
 #define DRM_IOCTL_VERSION32		DRM_IOWR(0x00, drm_version32_t)
 #define DRM_IOCTL_GET_UNIQUE32		DRM_IOWR(0x01, drm_unique32_t)
diff --git a/drivers/gpu/drm/drm_ioctl.c b/drivers/gpu/drm/drm_ioctl.c
index 904d7e9..2c0dde6 100644
--- a/drivers/gpu/drm/drm_ioctl.c
+++ b/drivers/gpu/drm/drm_ioctl.c
@@ -33,10 +33,10 @@
  * OTHER DEALINGS IN THE SOFTWARE.
  */
 
-#include "drmP.h"
-#include "drm_core.h"
+#include <drm/drmP.h>
+#include <drm/drm_core.h>
 
-#include "linux/pci.h"
+#include <linux/pci.h>
 
 /**
  * Get the bus id.
diff --git a/drivers/gpu/drm/drm_irq.c b/drivers/gpu/drm/drm_irq.c
index 2022a5c..c9481db 100644
--- a/drivers/gpu/drm/drm_irq.c
+++ b/drivers/gpu/drm/drm_irq.c
@@ -33,7 +33,7 @@
  * OTHER DEALINGS IN THE SOFTWARE.
  */
 
-#include "drmP.h"
+#include <drm/drmP.h>
 #include "drm_trace.h"
 
 #include <linux/interrupt.h>	/* For task queue support */
diff --git a/drivers/gpu/drm/drm_lock.c b/drivers/gpu/drm/drm_lock.c
index 632ae24..9886a9a 100644
--- a/drivers/gpu/drm/drm_lock.c
+++ b/drivers/gpu/drm/drm_lock.c
@@ -33,7 +33,7 @@
  * OTHER DEALINGS IN THE SOFTWARE.
  */
 
-#include "drmP.h"
+#include <drm/drmP.h>
 
 static int drm_notifier(void *priv);
 
diff --git a/drivers/gpu/drm/drm_memory.c b/drivers/gpu/drm/drm_memory.c
index c9b8050..8571466 100644
--- a/drivers/gpu/drm/drm_memory.c
+++ b/drivers/gpu/drm/drm_memory.c
@@ -34,7 +34,7 @@
  */
 
 #include <linux/highmem.h>
-#include "drmP.h"
+#include <drm/drmP.h>
 
 /**
  * Called when "/proc/dri/%dev%/mem" is read.
diff --git a/drivers/gpu/drm/drm_mm.c b/drivers/gpu/drm/drm_mm.c
index 959186c..e220cd9 100644
--- a/drivers/gpu/drm/drm_mm.c
+++ b/drivers/gpu/drm/drm_mm.c
@@ -41,8 +41,8 @@
  * Thomas Hellström <thomas-at-tungstengraphics-dot-com>
  */
 
-#include "drmP.h"
-#include "drm_mm.h"
+#include <drm/drmP.h>
+#include <drm/drm_mm.h>
 #include <linux/slab.h>
 #include <linux/seq_file.h>
 
diff --git a/drivers/gpu/drm/drm_modes.c b/drivers/gpu/drm/drm_modes.c
index ad74fb4..10fb0e9 100644
--- a/drivers/gpu/drm/drm_modes.c
+++ b/drivers/gpu/drm/drm_modes.c
@@ -32,9 +32,9 @@
 
 #include <linux/list.h>
 #include <linux/list_sort.h>
-#include "drmP.h"
-#include "drm.h"
-#include "drm_crtc.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/drm_crtc.h>
 
 /**
  * drm_mode_debug_printmodeline - debug print a mode
diff --git a/drivers/gpu/drm/drm_pci.c b/drivers/gpu/drm/drm_pci.c
index b6a19cb..ce6708d 100644
--- a/drivers/gpu/drm/drm_pci.c
+++ b/drivers/gpu/drm/drm_pci.c
@@ -39,7 +39,7 @@
 #include <linux/pci.h>
 #include <linux/slab.h>
 #include <linux/dma-mapping.h>
-#include "drmP.h"
+#include <drm/drmP.h>
 
 /**********************************************************************/
 /** \name PCI memory */
diff --git a/drivers/gpu/drm/drm_platform.c b/drivers/gpu/drm/drm_platform.c
index 2a8b626..b79dcf4 100644
--- a/drivers/gpu/drm/drm_platform.c
+++ b/drivers/gpu/drm/drm_platform.c
@@ -25,7 +25,7 @@
  * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
  */
 
-#include "drmP.h"
+#include <drm/drmP.h>
 
 /**
  * Register.
diff --git a/drivers/gpu/drm/drm_proc.c b/drivers/gpu/drm/drm_proc.c
index 9e5b07e..39191f9 100644
--- a/drivers/gpu/drm/drm_proc.c
+++ b/drivers/gpu/drm/drm_proc.c
@@ -39,7 +39,7 @@
 
 #include <linux/seq_file.h>
 #include <linux/slab.h>
-#include "drmP.h"
+#include <drm/drmP.h>
 
 /***************************************************
  * Initialization, etc.
diff --git a/drivers/gpu/drm/drm_scatter.c b/drivers/gpu/drm/drm_scatter.c
index 7525e03..d87f60b 100644
--- a/drivers/gpu/drm/drm_scatter.c
+++ b/drivers/gpu/drm/drm_scatter.c
@@ -33,7 +33,7 @@
 
 #include <linux/vmalloc.h>
 #include <linux/slab.h>
-#include "drmP.h"
+#include <drm/drmP.h>
 
 #define DEBUG_SCATTER 0
 
diff --git a/drivers/gpu/drm/drm_sman.c b/drivers/gpu/drm/drm_sman.c
index 3466458..84905da 100644
--- a/drivers/gpu/drm/drm_sman.c
+++ b/drivers/gpu/drm/drm_sman.c
@@ -36,7 +36,7 @@
  * Thomas Hellström <thomas-at-tungstengraphics-dot-com>
  */
 
-#include "drm_sman.h"
+#include <drm/drm_sman.h>
 
 struct drm_owner_item {
 	struct drm_hash_item owner_hash;
diff --git a/drivers/gpu/drm/drm_stub.c b/drivers/gpu/drm/drm_stub.c
index 6d7b083..df1587b 100644
--- a/drivers/gpu/drm/drm_stub.c
+++ b/drivers/gpu/drm/drm_stub.c
@@ -34,8 +34,8 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/slab.h>
-#include "drmP.h"
-#include "drm_core.h"
+#include <drm/drmP.h>
+#include <drm/drm_core.h>
 
 unsigned int drm_debug = 0;	/* 1 to enable debug output */
 EXPORT_SYMBOL(drm_debug);
diff --git a/drivers/gpu/drm/drm_sysfs.c b/drivers/gpu/drm/drm_sysfs.c
index 2eee8e0..395a0af 100644
--- a/drivers/gpu/drm/drm_sysfs.c
+++ b/drivers/gpu/drm/drm_sysfs.c
@@ -17,9 +17,9 @@
 #include <linux/gfp.h>
 #include <linux/err.h>
 
-#include "drm_sysfs.h"
-#include "drm_core.h"
-#include "drmP.h"
+#include <drm/drm_sysfs.h>
+#include <drm/drm_core.h>
+#include <drm/drmP.h>
 
 #define to_drm_minor(d) container_of(d, struct drm_minor, kdev)
 #define to_drm_connector(d) container_of(d, struct drm_connector, kdev)
diff --git a/drivers/gpu/drm/drm_trace_points.c b/drivers/gpu/drm/drm_trace_points.c
index 0d0eb90..3bbc4de 100644
--- a/drivers/gpu/drm/drm_trace_points.c
+++ b/drivers/gpu/drm/drm_trace_points.c
@@ -1,4 +1,4 @@
-#include "drmP.h"
+#include <drm/drmP.h>
 
 #define CREATE_TRACE_POINTS
 #include "drm_trace.h"
diff --git a/drivers/gpu/drm/drm_usb.c b/drivers/gpu/drm/drm_usb.c
index 206d230..4d270ea 100644
--- a/drivers/gpu/drm/drm_usb.c
+++ b/drivers/gpu/drm/drm_usb.c
@@ -1,4 +1,4 @@
-#include "drmP.h"
+#include <drm/drmP.h>
 #include <linux/usb.h>
 
 #ifdef CONFIG_USB
diff --git a/drivers/gpu/drm/drm_vm.c b/drivers/gpu/drm/drm_vm.c
index 5db96d45..ad58cd7 100644
--- a/drivers/gpu/drm/drm_vm.c
+++ b/drivers/gpu/drm/drm_vm.c
@@ -33,7 +33,7 @@
  * OTHER DEALINGS IN THE SOFTWARE.
  */
 
-#include "drmP.h"
+#include <drm/drmP.h>
 #if defined(__ia64__)
 #include <linux/efi.h>
 #include <linux/slab.h>
diff --git a/drivers/gpu/drm/i2c/ch7006_priv.h b/drivers/gpu/drm/i2c/ch7006_priv.h
index 17667b7..6738041 100644
--- a/drivers/gpu/drm/i2c/ch7006_priv.h
+++ b/drivers/gpu/drm/i2c/ch7006_priv.h
@@ -27,10 +27,10 @@
 #ifndef __DRM_I2C_CH7006_PRIV_H__
 #define __DRM_I2C_CH7006_PRIV_H__
 
-#include "drmP.h"
-#include "drm_crtc_helper.h"
-#include "drm_encoder_slave.h"
-#include "i2c/ch7006.h"
+#include <drm/drmP.h>
+#include <drm/drm_crtc_helper.h>
+#include <drm/drm_encoder_slave.h>
+#include <drm/i2c/ch7006.h>
 
 typedef int64_t fixed;
 #define fixed1 (1LL << 32)
diff --git a/drivers/gpu/drm/i2c/sil164_drv.c b/drivers/gpu/drm/i2c/sil164_drv.c
index 0b67732..6e2e6b1 100644
--- a/drivers/gpu/drm/i2c/sil164_drv.c
+++ b/drivers/gpu/drm/i2c/sil164_drv.c
@@ -24,10 +24,10 @@
  *
  */
 
-#include "drmP.h"
-#include "drm_crtc_helper.h"
-#include "drm_encoder_slave.h"
-#include "i2c/sil164.h"
+#include <drm/drmP.h>
+#include <drm/drm_crtc_helper.h>
+#include <drm/drm_encoder_slave.h>
+#include <drm/i2c/sil164.h>
 
 struct sil164_priv {
 	struct sil164_encoder_params config;
diff --git a/drivers/gpu/drm/i810/i810_dma.c b/drivers/gpu/drm/i810/i810_dma.c
index 8f371e8..fae014f 100644
--- a/drivers/gpu/drm/i810/i810_dma.c
+++ b/drivers/gpu/drm/i810/i810_dma.c
@@ -30,9 +30,9 @@
  *
  */
 
-#include "drmP.h"
-#include "drm.h"
-#include "i810_drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/i810_drm.h>
 #include "i810_drv.h"
 #include <linux/interrupt.h>	/* For task queue support */
 #include <linux/delay.h>
diff --git a/drivers/gpu/drm/i810/i810_drv.c b/drivers/gpu/drm/i810/i810_drv.c
index 6f98d05..f7e7d97 100644
--- a/drivers/gpu/drm/i810/i810_drv.c
+++ b/drivers/gpu/drm/i810/i810_drv.c
@@ -30,12 +30,12 @@
  *    Gareth Hughes <gareth@valinux.com>
  */
 
-#include "drmP.h"
-#include "drm.h"
-#include "i810_drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/i810_drm.h>
 #include "i810_drv.h"
 
-#include "drm_pciids.h"
+#include <drm/drm_pciids.h>
 
 static struct pci_device_id pciidlist[] = {
 	i810_PCI_IDS
diff --git a/drivers/gpu/drm/i915/dvo.h b/drivers/gpu/drm/i915/dvo.h
index 8c2ad01..a6607c3 100644
--- a/drivers/gpu/drm/i915/dvo.h
+++ b/drivers/gpu/drm/i915/dvo.h
@@ -24,9 +24,9 @@
 #define _INTEL_DVO_H
 
 #include <linux/i2c.h>
-#include "drmP.h"
-#include "drm.h"
-#include "drm_crtc.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/drm_crtc.h>
 #include "intel_drv.h"
 
 struct intel_dvo_device {
diff --git a/drivers/gpu/drm/i915/i915_debugfs.c b/drivers/gpu/drm/i915/i915_debugfs.c
index e2662497..6a78cd5 100644
--- a/drivers/gpu/drm/i915/i915_debugfs.c
+++ b/drivers/gpu/drm/i915/i915_debugfs.c
@@ -29,11 +29,11 @@
 #include <linux/seq_file.h>
 #include <linux/debugfs.h>
 #include <linux/slab.h>
-#include "drmP.h"
-#include "drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
 #include "intel_drv.h"
 #include "intel_ringbuffer.h"
-#include "i915_drm.h"
+#include <drm/i915_drm.h>
 #include "i915_drv.h"
 
 #define DRM_I915_RING_DEBUG 1
diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index 1271282..c771353 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -26,12 +26,12 @@
  *
  */
 
-#include "drmP.h"
-#include "drm.h"
-#include "drm_crtc_helper.h"
-#include "drm_fb_helper.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/drm_crtc_helper.h>
+#include <drm/drm_fb_helper.h>
 #include "intel_drv.h"
-#include "i915_drm.h"
+#include <drm/i915_drm.h>
 #include "i915_drv.h"
 #include "i915_trace.h"
 #include "../../../platform/x86/intel_ips.h"
diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
index ce045a8..2e2ead0 100644
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -28,14 +28,14 @@
  */
 
 #include <linux/device.h>
-#include "drmP.h"
-#include "drm.h"
-#include "i915_drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/i915_drm.h>
 #include "i915_drv.h"
 #include "intel_drv.h"
 
 #include <linux/console.h>
-#include "drm_crtc_helper.h"
+#include <drm/drm_crtc_helper.h>
 
 static int i915_modeset __read_mostly = -1;
 module_param_named(modeset, i915_modeset, int, 0400);
diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index d1cd8b8..49293e2 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -25,9 +25,9 @@
  *
  */
 
-#include "drmP.h"
-#include "drm.h"
-#include "i915_drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/i915_drm.h>
 #include "i915_drv.h"
 #include "i915_trace.h"
 #include "intel_drv.h"
diff --git a/drivers/gpu/drm/i915/i915_gem_debug.c b/drivers/gpu/drm/i915/i915_gem_debug.c
index 8da1899..f7785ea 100644
--- a/drivers/gpu/drm/i915/i915_gem_debug.c
+++ b/drivers/gpu/drm/i915/i915_gem_debug.c
@@ -25,9 +25,9 @@
  *
  */
 
-#include "drmP.h"
-#include "drm.h"
-#include "i915_drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/i915_drm.h>
 #include "i915_drv.h"
 
 #if WATCH_LISTS
diff --git a/drivers/gpu/drm/i915/i915_gem_evict.c b/drivers/gpu/drm/i915/i915_gem_evict.c
index da05a26..cfa4be7 100644
--- a/drivers/gpu/drm/i915/i915_gem_evict.c
+++ b/drivers/gpu/drm/i915/i915_gem_evict.c
@@ -26,10 +26,10 @@
  *
  */
 
-#include "drmP.h"
-#include "drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
 #include "i915_drv.h"
-#include "i915_drm.h"
+#include <drm/i915_drm.h>
 #include "i915_trace.h"
 
 static bool
diff --git a/drivers/gpu/drm/i915/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
index 4934cf8..9130b6d 100644
--- a/drivers/gpu/drm/i915/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
@@ -26,9 +26,9 @@
  *
  */
 
-#include "drmP.h"
-#include "drm.h"
-#include "i915_drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/i915_drm.h>
 #include "i915_drv.h"
 #include "i915_trace.h"
 #include "intel_drv.h"
diff --git a/drivers/gpu/drm/i915/i915_gem_gtt.c b/drivers/gpu/drm/i915/i915_gem_gtt.c
index 7a709cd..03c61b8 100644
--- a/drivers/gpu/drm/i915/i915_gem_gtt.c
+++ b/drivers/gpu/drm/i915/i915_gem_gtt.c
@@ -22,9 +22,9 @@
  *
  */
 
-#include "drmP.h"
-#include "drm.h"
-#include "i915_drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/i915_drm.h>
 #include "i915_drv.h"
 #include "i915_trace.h"
 #include "intel_drv.h"
diff --git a/drivers/gpu/drm/i915/i915_gem_tiling.c b/drivers/gpu/drm/i915/i915_gem_tiling.c
index 99c4faa..8ea9315 100644
--- a/drivers/gpu/drm/i915/i915_gem_tiling.c
+++ b/drivers/gpu/drm/i915/i915_gem_tiling.c
@@ -25,11 +25,11 @@
  *
  */
 
-#include "linux/string.h"
-#include "linux/bitops.h"
-#include "drmP.h"
-#include "drm.h"
-#include "i915_drm.h"
+#include <linux/string.h>
+#include <linux/bitops.h>
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/i915_drm.h>
 #include "i915_drv.h"
 
 /** @file i915_gem_tiling.c
diff --git a/drivers/gpu/drm/i915/i915_ioc32.c b/drivers/gpu/drm/i915/i915_ioc32.c
index 13b0289..b1a442b 100644
--- a/drivers/gpu/drm/i915/i915_ioc32.c
+++ b/drivers/gpu/drm/i915/i915_ioc32.c
@@ -31,9 +31,9 @@
  */
 #include <linux/compat.h>
 
-#include "drmP.h"
-#include "drm.h"
-#include "i915_drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/i915_drm.h>
 
 typedef struct _drm_i915_batchbuffer32 {
 	int start;		/* agp offset */
diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_irq.c
index 23d1ae6..4fcbc5a 100644
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -28,9 +28,9 @@
 
 #include <linux/sysrq.h>
 #include <linux/slab.h>
-#include "drmP.h"
-#include "drm.h"
-#include "i915_drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/i915_drm.h>
 #include "i915_drv.h"
 #include "i915_trace.h"
 #include "intel_drv.h"
diff --git a/drivers/gpu/drm/i915/i915_mem.c b/drivers/gpu/drm/i915/i915_mem.c
index 83b7b81..9bea60b 100644
--- a/drivers/gpu/drm/i915/i915_mem.c
+++ b/drivers/gpu/drm/i915/i915_mem.c
@@ -26,9 +26,9 @@
  *
  */
 
-#include "drmP.h"
-#include "drm.h"
-#include "i915_drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/i915_drm.h>
 #include "i915_drv.h"
 
 /* This memory manager is integrated into the global/local lru
diff --git a/drivers/gpu/drm/i915/i915_suspend.c b/drivers/gpu/drm/i915/i915_suspend.c
index 2857586..ffbbad3 100644
--- a/drivers/gpu/drm/i915/i915_suspend.c
+++ b/drivers/gpu/drm/i915/i915_suspend.c
@@ -24,9 +24,9 @@
  * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
  */
 
-#include "drmP.h"
-#include "drm.h"
-#include "i915_drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/i915_drm.h>
 #include "intel_drv.h"
 
 static bool i915_pipe_enabled(struct drm_device *dev, enum pipe pipe)
diff --git a/drivers/gpu/drm/i915/intel_acpi.c b/drivers/gpu/drm/i915/intel_acpi.c
index 2cb8e0b..eda3420 100644
--- a/drivers/gpu/drm/i915/intel_acpi.c
+++ b/drivers/gpu/drm/i915/intel_acpi.c
@@ -8,7 +8,7 @@
 #include <linux/vga_switcheroo.h>
 #include <acpi/acpi_drivers.h>
 
-#include "drmP.h"
+#include <drm/drmP.h>
 
 #define INTEL_DSM_REVISION_ID 1 /* For Calpella anyway... */
 
diff --git a/drivers/gpu/drm/i915/intel_bios.c b/drivers/gpu/drm/i915/intel_bios.c
index 61abef8..8290e63 100644
--- a/drivers/gpu/drm/i915/intel_bios.c
+++ b/drivers/gpu/drm/i915/intel_bios.c
@@ -25,9 +25,9 @@
  *
  */
 #include <drm/drm_dp_helper.h>
-#include "drmP.h"
-#include "drm.h"
-#include "i915_drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/i915_drm.h>
 #include "i915_drv.h"
 #include "intel_bios.h"
 
diff --git a/drivers/gpu/drm/i915/intel_bios.h b/drivers/gpu/drm/i915/intel_bios.h
index 5f8e4ed..725e447 100644
--- a/drivers/gpu/drm/i915/intel_bios.h
+++ b/drivers/gpu/drm/i915/intel_bios.h
@@ -28,7 +28,7 @@
 #ifndef _I830_BIOS_H_
 #define _I830_BIOS_H_
 
-#include "drmP.h"
+#include <drm/drmP.h>
 
 struct vbt_header {
 	u8 signature[20];		/**< Always starts with 'VBT$' */
diff --git a/drivers/gpu/drm/i915/intel_crt.c b/drivers/gpu/drm/i915/intel_crt.c
index 0979d88..69a4ac7 100644
--- a/drivers/gpu/drm/i915/intel_crt.c
+++ b/drivers/gpu/drm/i915/intel_crt.c
@@ -26,13 +26,13 @@
 
 #include <linux/i2c.h>
 #include <linux/slab.h>
-#include "drmP.h"
-#include "drm.h"
-#include "drm_crtc.h"
-#include "drm_crtc_helper.h"
-#include "drm_edid.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/drm_crtc.h>
+#include <drm/drm_crtc_helper.h>
+#include <drm/drm_edid.h>
 #include "intel_drv.h"
-#include "i915_drm.h"
+#include <drm/i915_drm.h>
 #include "i915_drv.h"
 
 /* Here's the desired hotplug mode */
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 393a399..657f260 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -31,14 +31,14 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/vgaarb.h>
-#include "drmP.h"
+#include <drm/drmP.h>
 #include "intel_drv.h"
-#include "i915_drm.h"
+#include <drm/i915_drm.h>
 #include "i915_drv.h"
 #include "i915_trace.h"
-#include "drm_dp_helper.h"
+#include <drm/drm_dp_helper.h>
 
-#include "drm_crtc_helper.h"
+#include <drm/drm_crtc_helper.h>
 
 #define HAS_eDP (intel_pipe_has_type(crtc, INTEL_OUTPUT_EDP))
 
diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index f797fb5..48c289a 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -27,14 +27,14 @@
 
 #include <linux/i2c.h>
 #include <linux/slab.h>
-#include "drmP.h"
-#include "drm.h"
-#include "drm_crtc.h"
-#include "drm_crtc_helper.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/drm_crtc.h>
+#include <drm/drm_crtc_helper.h>
 #include "intel_drv.h"
-#include "i915_drm.h"
+#include <drm/i915_drm.h>
 #include "i915_drv.h"
-#include "drm_dp_helper.h"
+#include <drm/drm_dp_helper.h>
 
 
 #define DP_LINK_STATUS_SIZE	6
diff --git a/drivers/gpu/drm/i915/intel_drv.h b/drivers/gpu/drm/i915/intel_drv.h
index 6e990f9..88367a3 100644
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@ -27,9 +27,9 @@
 
 #include <linux/i2c.h>
 #include "i915_drv.h"
-#include "drm_crtc.h"
-#include "drm_crtc_helper.h"
-#include "drm_fb_helper.h"
+#include <drm/drm_crtc.h>
+#include <drm/drm_crtc_helper.h>
+#include <drm/drm_fb_helper.h>
 
 #define _wait_for(COND, MS, W) ({ \
 	unsigned long timeout__ = jiffies + msecs_to_jiffies(MS);	\
diff --git a/drivers/gpu/drm/i915/intel_dvo.c b/drivers/gpu/drm/i915/intel_dvo.c
index 6eda1b5..1d95b7a 100644
--- a/drivers/gpu/drm/i915/intel_dvo.c
+++ b/drivers/gpu/drm/i915/intel_dvo.c
@@ -26,11 +26,11 @@
  */
 #include <linux/i2c.h>
 #include <linux/slab.h>
-#include "drmP.h"
-#include "drm.h"
-#include "drm_crtc.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/drm_crtc.h>
 #include "intel_drv.h"
-#include "i915_drm.h"
+#include <drm/i915_drm.h>
 #include "i915_drv.h"
 #include "dvo.h"
 
diff --git a/drivers/gpu/drm/i915/intel_fb.c b/drivers/gpu/drm/i915/intel_fb.c
index ec49bae..0cc5fcf 100644
--- a/drivers/gpu/drm/i915/intel_fb.c
+++ b/drivers/gpu/drm/i915/intel_fb.c
@@ -36,12 +36,12 @@
 #include <linux/init.h>
 #include <linux/vga_switcheroo.h>
 
-#include "drmP.h"
-#include "drm.h"
-#include "drm_crtc.h"
-#include "drm_fb_helper.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/drm_crtc.h>
+#include <drm/drm_fb_helper.h>
 #include "intel_drv.h"
-#include "i915_drm.h"
+#include <drm/i915_drm.h>
 #include "i915_drv.h"
 
 static struct fb_ops intelfb_ops = {
diff --git a/drivers/gpu/drm/i915/intel_hdmi.c b/drivers/gpu/drm/i915/intel_hdmi.c
index 1ed8e69..2977cc2 100644
--- a/drivers/gpu/drm/i915/intel_hdmi.c
+++ b/drivers/gpu/drm/i915/intel_hdmi.c
@@ -29,12 +29,12 @@
 #include <linux/i2c.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
-#include "drmP.h"
-#include "drm.h"
-#include "drm_crtc.h"
-#include "drm_edid.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/drm_crtc.h>
+#include <drm/drm_edid.h>
 #include "intel_drv.h"
-#include "i915_drm.h"
+#include <drm/i915_drm.h>
 #include "i915_drv.h"
 
 struct intel_hdmi {
diff --git a/drivers/gpu/drm/i915/intel_i2c.c b/drivers/gpu/drm/i915/intel_i2c.c
index d98cee6..45b948f 100644
--- a/drivers/gpu/drm/i915/intel_i2c.c
+++ b/drivers/gpu/drm/i915/intel_i2c.c
@@ -28,10 +28,10 @@
  */
 #include <linux/i2c.h>
 #include <linux/i2c-algo-bit.h>
-#include "drmP.h"
-#include "drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
 #include "intel_drv.h"
-#include "i915_drm.h"
+#include <drm/i915_drm.h>
 #include "i915_drv.h"
 
 /* Intel GPIO access functions */
diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index b28f7bd..12ecb19 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -31,12 +31,12 @@
 #include <linux/dmi.h>
 #include <linux/i2c.h>
 #include <linux/slab.h>
-#include "drmP.h"
-#include "drm.h"
-#include "drm_crtc.h"
-#include "drm_edid.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/drm_crtc.h>
+#include <drm/drm_edid.h>
 #include "intel_drv.h"
-#include "i915_drm.h"
+#include <drm/i915_drm.h>
 #include "i915_drv.h"
 #include <linux/acpi.h>
 
diff --git a/drivers/gpu/drm/i915/intel_modes.c b/drivers/gpu/drm/i915/intel_modes.c
index 3b26a3b..216db30 100644
--- a/drivers/gpu/drm/i915/intel_modes.c
+++ b/drivers/gpu/drm/i915/intel_modes.c
@@ -26,7 +26,7 @@
 #include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/fb.h>
-#include "drmP.h"
+#include <drm/drmP.h>
 #include "intel_drv.h"
 #include "i915_drv.h"
 
diff --git a/drivers/gpu/drm/i915/intel_opregion.c b/drivers/gpu/drm/i915/intel_opregion.c
index b7c5ddb..a794861 100644
--- a/drivers/gpu/drm/i915/intel_opregion.c
+++ b/drivers/gpu/drm/i915/intel_opregion.c
@@ -29,8 +29,8 @@
 #include <linux/acpi_io.h>
 #include <acpi/video.h>
 
-#include "drmP.h"
-#include "i915_drm.h"
+#include <drm/drmP.h>
+#include <drm/i915_drm.h>
 #include "i915_drv.h"
 #include "intel_drv.h"
 
diff --git a/drivers/gpu/drm/i915/intel_overlay.c b/drivers/gpu/drm/i915/intel_overlay.c
index d360380..27042b4 100644
--- a/drivers/gpu/drm/i915/intel_overlay.c
+++ b/drivers/gpu/drm/i915/intel_overlay.c
@@ -27,9 +27,9 @@
  */
 
 #include <linux/seq_file.h>
-#include "drmP.h"
-#include "drm.h"
-#include "i915_drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/i915_drm.h>
 #include "i915_drv.h"
 #include "i915_reg.h"
 #include "intel_drv.h"
diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.c b/drivers/gpu/drm/i915/intel_ringbuffer.c
index e961568..2af000c 100644
--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -27,10 +27,10 @@
  *
  */
 
-#include "drmP.h"
-#include "drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
 #include "i915_drv.h"
-#include "i915_drm.h"
+#include <drm/i915_drm.h>
 #include "i915_trace.h"
 #include "intel_drv.h"
 
diff --git a/drivers/gpu/drm/i915/intel_sdvo.c b/drivers/gpu/drm/i915/intel_sdvo.c
index 30fe554..77fd5d1 100644
--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@ -28,12 +28,12 @@
 #include <linux/i2c.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
-#include "drmP.h"
-#include "drm.h"
-#include "drm_crtc.h"
-#include "drm_edid.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/drm_crtc.h>
+#include <drm/drm_edid.h>
 #include "intel_drv.h"
-#include "i915_drm.h"
+#include <drm/i915_drm.h>
 #include "i915_drv.h"
 #include "intel_sdvo_regs.h"
 
diff --git a/drivers/gpu/drm/i915/intel_tv.c b/drivers/gpu/drm/i915/intel_tv.c
index 210d570..ed2611c 100644
--- a/drivers/gpu/drm/i915/intel_tv.c
+++ b/drivers/gpu/drm/i915/intel_tv.c
@@ -30,12 +30,12 @@
  * Integrated TV-out support for the 915GM and 945GM.
  */
 
-#include "drmP.h"
-#include "drm.h"
-#include "drm_crtc.h"
-#include "drm_edid.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/drm_crtc.h>
+#include <drm/drm_edid.h>
 #include "intel_drv.h"
-#include "i915_drm.h"
+#include <drm/i915_drm.h>
 #include "i915_drv.h"
 
 enum tv_margin {
diff --git a/drivers/gpu/drm/mga/mga_dma.c b/drivers/gpu/drm/mga/mga_dma.c
index 5ccb65d..2bbda7e 100644
--- a/drivers/gpu/drm/mga/mga_dma.c
+++ b/drivers/gpu/drm/mga/mga_dma.c
@@ -35,10 +35,10 @@
  * \author Gareth Hughes <gareth@valinux.com>
  */
 
-#include "drmP.h"
-#include "drm.h"
-#include "drm_sarea.h"
-#include "mga_drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/drm_sarea.h>
+#include <drm/mga_drm.h>
 #include "mga_drv.h"
 
 #define MGA_DEFAULT_USEC_TIMEOUT	10000
diff --git a/drivers/gpu/drm/mga/mga_drv.c b/drivers/gpu/drm/mga/mga_drv.c
index 42d3187..5f92d5f 100644
--- a/drivers/gpu/drm/mga/mga_drv.c
+++ b/drivers/gpu/drm/mga/mga_drv.c
@@ -29,12 +29,12 @@
  *    Gareth Hughes <gareth@valinux.com>
  */
 
-#include "drmP.h"
-#include "drm.h"
-#include "mga_drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/mga_drm.h>
 #include "mga_drv.h"
 
-#include "drm_pciids.h"
+#include <drm/drm_pciids.h>
 
 static int mga_driver_device_is_agp(struct drm_device *dev);
 
diff --git a/drivers/gpu/drm/mga/mga_ioc32.c b/drivers/gpu/drm/mga/mga_ioc32.c
index c1f877b..8909ec1 100644
--- a/drivers/gpu/drm/mga/mga_ioc32.c
+++ b/drivers/gpu/drm/mga/mga_ioc32.c
@@ -32,9 +32,9 @@
  */
 #include <linux/compat.h>
 
-#include "drmP.h"
-#include "drm.h"
-#include "mga_drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/mga_drm.h>
 
 typedef struct drm32_mga_init {
 	int func;
diff --git a/drivers/gpu/drm/mga/mga_irq.c b/drivers/gpu/drm/mga/mga_irq.c
index 2581202..f81bbff 100644
--- a/drivers/gpu/drm/mga/mga_irq.c
+++ b/drivers/gpu/drm/mga/mga_irq.c
@@ -31,9 +31,9 @@
  *    Eric Anholt <anholt@FreeBSD.org>
  */
 
-#include "drmP.h"
-#include "drm.h"
-#include "mga_drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/mga_drm.h>
 #include "mga_drv.h"
 
 u32 mga_get_vblank_counter(struct drm_device *dev, int crtc)
diff --git a/drivers/gpu/drm/mga/mga_state.c b/drivers/gpu/drm/mga/mga_state.c
index 9ce2827f..975e067 100644
--- a/drivers/gpu/drm/mga/mga_state.c
+++ b/drivers/gpu/drm/mga/mga_state.c
@@ -32,9 +32,9 @@
  *    Gareth Hughes <gareth@valinux.com>
  */
 
-#include "drmP.h"
-#include "drm.h"
-#include "mga_drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/mga_drm.h>
 #include "mga_drv.h"
 
 /* ================================================================
diff --git a/drivers/gpu/drm/mga/mga_warp.c b/drivers/gpu/drm/mga/mga_warp.c
index f172bd5..2244890 100644
--- a/drivers/gpu/drm/mga/mga_warp.c
+++ b/drivers/gpu/drm/mga/mga_warp.c
@@ -31,9 +31,9 @@
 #include <linux/ihex.h>
 #include <linux/platform_device.h>
 
-#include "drmP.h"
-#include "drm.h"
-#include "mga_drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/mga_drm.h>
 #include "mga_drv.h"
 
 #define FIRMWARE_G200 "matrox/g200_warp.fw"
diff --git a/drivers/gpu/drm/nouveau/nouveau_acpi.c b/drivers/gpu/drm/nouveau/nouveau_acpi.c
index 525744d..1141cb7 100644
--- a/drivers/gpu/drm/nouveau/nouveau_acpi.c
+++ b/drivers/gpu/drm/nouveau/nouveau_acpi.c
@@ -7,12 +7,12 @@
 #include <acpi/acpi.h>
 #include <linux/mxm-wmi.h>
 
-#include "drmP.h"
-#include "drm.h"
-#include "drm_sarea.h"
-#include "drm_crtc_helper.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/drm_sarea.h>
+#include <drm/drm_crtc_helper.h>
 #include "nouveau_drv.h"
-#include "nouveau_drm.h"
+#include <drm/nouveau_drm.h>
 #include "nv50_display.h"
 #include "nouveau_connector.h"
 
diff --git a/drivers/gpu/drm/nouveau/nouveau_backlight.c b/drivers/gpu/drm/nouveau/nouveau_backlight.c
index 00a55df..33c12cb 100644
--- a/drivers/gpu/drm/nouveau/nouveau_backlight.c
+++ b/drivers/gpu/drm/nouveau/nouveau_backlight.c
@@ -33,9 +33,9 @@
 #include <linux/backlight.h>
 #include <linux/acpi.h>
 
-#include "drmP.h"
+#include <drm/drmP.h>
 #include "nouveau_drv.h"
-#include "nouveau_drm.h"
+#include <drm/nouveau_drm.h>
 #include "nouveau_reg.h"
 
 static int nv40_get_intensity(struct backlight_device *bd)
diff --git a/drivers/gpu/drm/nouveau/nouveau_bios.c b/drivers/gpu/drm/nouveau/nouveau_bios.c
index b311fab..b5c1e5f 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bios.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bios.c
@@ -22,7 +22,7 @@
  * SOFTWARE.
  */
 
-#include "drmP.h"
+#include <drm/drmP.h>
 #define NV_DEBUG_NOTRACE
 #include "nouveau_drv.h"
 #include "nouveau_hw.h"
diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c b/drivers/gpu/drm/nouveau/nouveau_bo.c
index 890d50e..e0bcfe9 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bo.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
@@ -27,9 +27,9 @@
  *	    Jeremy Kolb  <jkolb@brandeis.edu>
  */
 
-#include "drmP.h"
+#include <drm/drmP.h>
 
-#include "nouveau_drm.h"
+#include <drm/nouveau_drm.h>
 #include "nouveau_drv.h"
 #include "nouveau_dma.h"
 #include "nouveau_mm.h"
diff --git a/drivers/gpu/drm/nouveau/nouveau_calc.c b/drivers/gpu/drm/nouveau/nouveau_calc.c
index dad96cc..2c5eb5d 100644
--- a/drivers/gpu/drm/nouveau/nouveau_calc.c
+++ b/drivers/gpu/drm/nouveau/nouveau_calc.c
@@ -21,7 +21,7 @@
  * SOFTWARE.
  */
 
-#include "drmP.h"
+#include <drm/drmP.h>
 #include "nouveau_drv.h"
 #include "nouveau_hw.h"
 
diff --git a/drivers/gpu/drm/nouveau/nouveau_channel.c b/drivers/gpu/drm/nouveau/nouveau_channel.c
index b0d753f..bb56ecd 100644
--- a/drivers/gpu/drm/nouveau/nouveau_channel.c
+++ b/drivers/gpu/drm/nouveau/nouveau_channel.c
@@ -22,10 +22,10 @@
  * DEALINGS IN THE SOFTWARE.
  */
 
-#include "drmP.h"
-#include "drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
 #include "nouveau_drv.h"
-#include "nouveau_drm.h"
+#include <drm/nouveau_drm.h>
 #include "nouveau_dma.h"
 #include "nouveau_ramht.h"
 
diff --git a/drivers/gpu/drm/nouveau/nouveau_connector.c b/drivers/gpu/drm/nouveau/nouveau_connector.c
index 939d4df..8213458 100644
--- a/drivers/gpu/drm/nouveau/nouveau_connector.c
+++ b/drivers/gpu/drm/nouveau/nouveau_connector.c
@@ -26,9 +26,9 @@
 
 #include <acpi/button.h>
 
-#include "drmP.h"
-#include "drm_edid.h"
-#include "drm_crtc_helper.h"
+#include <drm/drmP.h>
+#include <drm/drm_edid.h>
+#include <drm/drm_crtc_helper.h>
 
 #include "nouveau_reg.h"
 #include "nouveau_drv.h"
diff --git a/drivers/gpu/drm/nouveau/nouveau_connector.h b/drivers/gpu/drm/nouveau/nouveau_connector.h
index 711b1e9..6dd3048 100644
--- a/drivers/gpu/drm/nouveau/nouveau_connector.h
+++ b/drivers/gpu/drm/nouveau/nouveau_connector.h
@@ -27,7 +27,7 @@
 #ifndef __NOUVEAU_CONNECTOR_H__
 #define __NOUVEAU_CONNECTOR_H__
 
-#include "drm_edid.h"
+#include <drm/drm_edid.h>
 #include "nouveau_i2c.h"
 
 struct nouveau_connector {
diff --git a/drivers/gpu/drm/nouveau/nouveau_debugfs.c b/drivers/gpu/drm/nouveau/nouveau_debugfs.c
index 8e15923..e1dda1c 100644
--- a/drivers/gpu/drm/nouveau/nouveau_debugfs.c
+++ b/drivers/gpu/drm/nouveau/nouveau_debugfs.c
@@ -30,7 +30,7 @@
 
 #include <linux/debugfs.h>
 
-#include "drmP.h"
+#include <drm/drmP.h>
 #include "nouveau_drv.h"
 
 #include <ttm/ttm_page_alloc.h>
diff --git a/drivers/gpu/drm/nouveau/nouveau_display.c b/drivers/gpu/drm/nouveau/nouveau_display.c
index eb514ea..7ee5741 100644
--- a/drivers/gpu/drm/nouveau/nouveau_display.c
+++ b/drivers/gpu/drm/nouveau/nouveau_display.c
@@ -24,8 +24,8 @@
  *
  */
 
-#include "drmP.h"
-#include "drm_crtc_helper.h"
+#include <drm/drmP.h>
+#include <drm/drm_crtc_helper.h>
 #include "nouveau_drv.h"
 #include "nouveau_fb.h"
 #include "nouveau_fbcon.h"
diff --git a/drivers/gpu/drm/nouveau/nouveau_dma.c b/drivers/gpu/drm/nouveau/nouveau_dma.c
index 00bc6ea..8c7c438 100644
--- a/drivers/gpu/drm/nouveau/nouveau_dma.c
+++ b/drivers/gpu/drm/nouveau/nouveau_dma.c
@@ -24,8 +24,8 @@
  *
  */
 
-#include "drmP.h"
-#include "drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
 #include "nouveau_drv.h"
 #include "nouveau_dma.h"
 #include "nouveau_ramht.h"
diff --git a/drivers/gpu/drm/nouveau/nouveau_dp.c b/drivers/gpu/drm/nouveau/nouveau_dp.c
index 7beb82a..40af3fb 100644
--- a/drivers/gpu/drm/nouveau/nouveau_dp.c
+++ b/drivers/gpu/drm/nouveau/nouveau_dp.c
@@ -22,7 +22,7 @@
  * Authors: Ben Skeggs
  */
 
-#include "drmP.h"
+#include <drm/drmP.h>
 
 #include "nouveau_drv.h"
 #include "nouveau_i2c.h"
diff --git a/drivers/gpu/drm/nouveau/nouveau_drv.c b/drivers/gpu/drm/nouveau/nouveau_drv.c
index b30ddd8..2c783ab 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drv.c
+++ b/drivers/gpu/drm/nouveau/nouveau_drv.c
@@ -24,9 +24,9 @@
 
 #include <linux/console.h>
 
-#include "drmP.h"
-#include "drm.h"
-#include "drm_crtc_helper.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/drm_crtc_helper.h>
 #include "nouveau_drv.h"
 #include "nouveau_hw.h"
 #include "nouveau_fb.h"
@@ -34,7 +34,7 @@
 #include "nouveau_pm.h"
 #include "nv50_display.h"
 
-#include "drm_pciids.h"
+#include <drm/drm_pciids.h>
 
 MODULE_PARM_DESC(agpmode, "AGP mode (0 to disable AGP)");
 int nouveau_agpmode = -1;
diff --git a/drivers/gpu/drm/nouveau/nouveau_drv.h b/drivers/gpu/drm/nouveau/nouveau_drv.h
index d7d51de..c24f139 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drv.h
+++ b/drivers/gpu/drm/nouveau/nouveau_drv.h
@@ -39,11 +39,11 @@
 #define NOUVEAU_FAMILY   0x0000FFFF
 #define NOUVEAU_FLAGS    0xFFFF0000
 
-#include "ttm/ttm_bo_api.h"
-#include "ttm/ttm_bo_driver.h"
-#include "ttm/ttm_placement.h"
-#include "ttm/ttm_memory.h"
-#include "ttm/ttm_module.h"
+#include <drm/ttm/ttm_bo_api.h>
+#include <drm/ttm/ttm_bo_driver.h>
+#include <drm/ttm/ttm_placement.h>
+#include <drm/ttm/ttm_memory.h>
+#include <drm/ttm/ttm_module.h>
 
 struct nouveau_fpriv {
 	spinlock_t lock;
@@ -59,7 +59,7 @@ nouveau_fpriv(struct drm_file *file_priv)
 
 #define DRM_FILE_PAGE_OFFSET (0x100000000ULL >> PAGE_SHIFT)
 
-#include "nouveau_drm.h"
+#include <drm/nouveau_drm.h>
 #include "nouveau_reg.h"
 #include "nouveau_bios.h"
 #include "nouveau_util.h"
diff --git a/drivers/gpu/drm/nouveau/nouveau_encoder.h b/drivers/gpu/drm/nouveau/nouveau_encoder.h
index ae69b61..ddf3339 100644
--- a/drivers/gpu/drm/nouveau/nouveau_encoder.h
+++ b/drivers/gpu/drm/nouveau/nouveau_encoder.h
@@ -27,7 +27,7 @@
 #ifndef __NOUVEAU_ENCODER_H__
 #define __NOUVEAU_ENCODER_H__
 
-#include "drm_encoder_slave.h"
+#include <drm/drm_encoder_slave.h>
 #include "nouveau_drv.h"
 
 #define NV_DPMS_CLEARED 0x80
diff --git a/drivers/gpu/drm/nouveau/nouveau_fbcon.c b/drivers/gpu/drm/nouveau/nouveau_fbcon.c
index 14a8627..302ef19 100644
--- a/drivers/gpu/drm/nouveau/nouveau_fbcon.c
+++ b/drivers/gpu/drm/nouveau/nouveau_fbcon.c
@@ -37,13 +37,13 @@
 #include <linux/screen_info.h>
 #include <linux/vga_switcheroo.h>
 
-#include "drmP.h"
-#include "drm.h"
-#include "drm_crtc.h"
-#include "drm_crtc_helper.h"
-#include "drm_fb_helper.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/drm_crtc.h>
+#include <drm/drm_crtc_helper.h>
+#include <drm/drm_fb_helper.h>
 #include "nouveau_drv.h"
-#include "nouveau_drm.h"
+#include <drm/nouveau_drm.h>
 #include "nouveau_crtc.h"
 #include "nouveau_fb.h"
 #include "nouveau_fbcon.h"
diff --git a/drivers/gpu/drm/nouveau/nouveau_fbcon.h b/drivers/gpu/drm/nouveau/nouveau_fbcon.h
index b73c29f8..1f2d278 100644
--- a/drivers/gpu/drm/nouveau/nouveau_fbcon.h
+++ b/drivers/gpu/drm/nouveau/nouveau_fbcon.h
@@ -27,7 +27,7 @@
 #ifndef __NOUVEAU_FBCON_H__
 #define __NOUVEAU_FBCON_H__
 
-#include "drm_fb_helper.h"
+#include <drm/drm_fb_helper.h>
 
 #include "nouveau_fb.h"
 struct nouveau_fbdev {
diff --git a/drivers/gpu/drm/nouveau/nouveau_fence.c b/drivers/gpu/drm/nouveau/nouveau_fence.c
index 8d02d87..1cbfac6 100644
--- a/drivers/gpu/drm/nouveau/nouveau_fence.c
+++ b/drivers/gpu/drm/nouveau/nouveau_fence.c
@@ -24,8 +24,8 @@
  *
  */
 
-#include "drmP.h"
-#include "drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
 
 #include <linux/ktime.h>
 #include <linux/hrtimer.h>
diff --git a/drivers/gpu/drm/nouveau/nouveau_gem.c b/drivers/gpu/drm/nouveau/nouveau_gem.c
index 5f0bc57..8d24653 100644
--- a/drivers/gpu/drm/nouveau/nouveau_gem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_gem.c
@@ -23,11 +23,11 @@
  * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
  *
  */
-#include "drmP.h"
-#include "drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
 
 #include "nouveau_drv.h"
-#include "nouveau_drm.h"
+#include <drm/nouveau_drm.h>
 #include "nouveau_dma.h"
 
 #define nouveau_gem_pushbuf_sync(chan) 0
diff --git a/drivers/gpu/drm/nouveau/nouveau_hw.c b/drivers/gpu/drm/nouveau/nouveau_hw.c
index ba896e5..bf30076 100644
--- a/drivers/gpu/drm/nouveau/nouveau_hw.c
+++ b/drivers/gpu/drm/nouveau/nouveau_hw.c
@@ -22,7 +22,7 @@
  * SOFTWARE.
  */
 
-#include "drmP.h"
+#include <drm/drmP.h>
 #include "nouveau_drv.h"
 #include "nouveau_hw.h"
 
diff --git a/drivers/gpu/drm/nouveau/nouveau_hw.h b/drivers/gpu/drm/nouveau/nouveau_hw.h
index 2989090..06a66bc 100644
--- a/drivers/gpu/drm/nouveau/nouveau_hw.h
+++ b/drivers/gpu/drm/nouveau/nouveau_hw.h
@@ -23,7 +23,7 @@
 #ifndef __NOUVEAU_HW_H__
 #define __NOUVEAU_HW_H__
 
-#include "drmP.h"
+#include <drm/drmP.h>
 #include "nouveau_drv.h"
 
 #define MASK(field) ( \
diff --git a/drivers/gpu/drm/nouveau/nouveau_i2c.c b/drivers/gpu/drm/nouveau/nouveau_i2c.c
index cb389d0..01bc254 100644
--- a/drivers/gpu/drm/nouveau/nouveau_i2c.c
+++ b/drivers/gpu/drm/nouveau/nouveau_i2c.c
@@ -22,7 +22,7 @@
  * Authors: Ben Skeggs
  */
 
-#include "drmP.h"
+#include <drm/drmP.h>
 #include "nouveau_drv.h"
 #include "nouveau_i2c.h"
 #include "nouveau_hw.h"
diff --git a/drivers/gpu/drm/nouveau/nouveau_i2c.h b/drivers/gpu/drm/nouveau/nouveau_i2c.h
index 422b62f..79ffd59 100644
--- a/drivers/gpu/drm/nouveau/nouveau_i2c.h
+++ b/drivers/gpu/drm/nouveau/nouveau_i2c.h
@@ -25,7 +25,7 @@
 
 #include <linux/i2c.h>
 #include <linux/i2c-algo-bit.h>
-#include "drm_dp_helper.h"
+#include <drm/drm_dp_helper.h>
 
 struct dcb_i2c_entry;
 
diff --git a/drivers/gpu/drm/nouveau/nouveau_ioc32.c b/drivers/gpu/drm/nouveau/nouveau_ioc32.c
index 475ba81..c26afa7 100644
--- a/drivers/gpu/drm/nouveau/nouveau_ioc32.c
+++ b/drivers/gpu/drm/nouveau/nouveau_ioc32.c
@@ -33,8 +33,8 @@
 
 #include <linux/compat.h>
 
-#include "drmP.h"
-#include "drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
 
 #include "nouveau_drv.h"
 
diff --git a/drivers/gpu/drm/nouveau/nouveau_irq.c b/drivers/gpu/drm/nouveau/nouveau_irq.c
index 868c7fd..99faed1 100644
--- a/drivers/gpu/drm/nouveau/nouveau_irq.c
+++ b/drivers/gpu/drm/nouveau/nouveau_irq.c
@@ -30,9 +30,9 @@
  *   Ben Skeggs <darktama@iinet.net.au>
  */
 
-#include "drmP.h"
-#include "drm.h"
-#include "nouveau_drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/nouveau_drm.h>
 #include "nouveau_drv.h"
 #include "nouveau_reg.h"
 #include "nouveau_ramht.h"
diff --git a/drivers/gpu/drm/nouveau/nouveau_mem.c b/drivers/gpu/drm/nouveau/nouveau_mem.c
index f9ae2fc..26b60fd 100644
--- a/drivers/gpu/drm/nouveau/nouveau_mem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_mem.c
@@ -30,9 +30,9 @@
  */
 
 
-#include "drmP.h"
-#include "drm.h"
-#include "drm_sarea.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/drm_sarea.h>
 
 #include "nouveau_drv.h"
 #include "nouveau_pm.h"
diff --git a/drivers/gpu/drm/nouveau/nouveau_mm.c b/drivers/gpu/drm/nouveau/nouveau_mm.c
index 1640dec..0fabc02 100644
--- a/drivers/gpu/drm/nouveau/nouveau_mm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_mm.c
@@ -22,7 +22,7 @@
  * Authors: Ben Skeggs
  */
 
-#include "drmP.h"
+#include <drm/drmP.h>
 #include "nouveau_drv.h"
 #include "nouveau_mm.h"
 
diff --git a/drivers/gpu/drm/nouveau/nouveau_notifier.c b/drivers/gpu/drm/nouveau/nouveau_notifier.c
index 6abdbe6..59a0cd6 100644
--- a/drivers/gpu/drm/nouveau/nouveau_notifier.c
+++ b/drivers/gpu/drm/nouveau/nouveau_notifier.c
@@ -25,8 +25,8 @@
  *
  */
 
-#include "drmP.h"
-#include "drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
 #include "nouveau_drv.h"
 #include "nouveau_ramht.h"
 
diff --git a/drivers/gpu/drm/nouveau/nouveau_object.c b/drivers/gpu/drm/nouveau/nouveau_object.c
index 159b7c4..8bc5faf 100644
--- a/drivers/gpu/drm/nouveau/nouveau_object.c
+++ b/drivers/gpu/drm/nouveau/nouveau_object.c
@@ -30,10 +30,10 @@
  *   Ben Skeggs <darktama@iinet.net.au>
  */
 
-#include "drmP.h"
-#include "drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
 #include "nouveau_drv.h"
-#include "nouveau_drm.h"
+#include <drm/nouveau_drm.h>
 #include "nouveau_ramht.h"
 #include "nouveau_vm.h"
 #include "nv50_display.h"
diff --git a/drivers/gpu/drm/nouveau/nouveau_perf.c b/drivers/gpu/drm/nouveau/nouveau_perf.c
index ef9dec0..0b4c60c 100644
--- a/drivers/gpu/drm/nouveau/nouveau_perf.c
+++ b/drivers/gpu/drm/nouveau/nouveau_perf.c
@@ -22,7 +22,7 @@
  * Authors: Ben Skeggs
  */
 
-#include "drmP.h"
+#include <drm/drmP.h>
 
 #include "nouveau_drv.h"
 #include "nouveau_pm.h"
diff --git a/drivers/gpu/drm/nouveau/nouveau_pm.c b/drivers/gpu/drm/nouveau/nouveau_pm.c
index da8d994..10c2a38 100644
--- a/drivers/gpu/drm/nouveau/nouveau_pm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_pm.c
@@ -22,7 +22,7 @@
  * Authors: Ben Skeggs
  */
 
-#include "drmP.h"
+#include <drm/drmP.h>
 
 #include "nouveau_drv.h"
 #include "nouveau_pm.h"
diff --git a/drivers/gpu/drm/nouveau/nouveau_ramht.c b/drivers/gpu/drm/nouveau/nouveau_ramht.c
index a24a81f..0ebb62f 100644
--- a/drivers/gpu/drm/nouveau/nouveau_ramht.c
+++ b/drivers/gpu/drm/nouveau/nouveau_ramht.c
@@ -22,7 +22,7 @@
  * Authors: Ben Skeggs
  */
 
-#include "drmP.h"
+#include <drm/drmP.h>
 
 #include "nouveau_drv.h"
 #include "nouveau_ramht.h"
diff --git a/drivers/gpu/drm/nouveau/nouveau_sgdma.c b/drivers/gpu/drm/nouveau/nouveau_sgdma.c
index c444cad..89e3025 100644
--- a/drivers/gpu/drm/nouveau/nouveau_sgdma.c
+++ b/drivers/gpu/drm/nouveau/nouveau_sgdma.c
@@ -1,4 +1,4 @@
-#include "drmP.h"
+#include <drm/drmP.h>
 #include "nouveau_drv.h"
 #include <linux/pagemap.h>
 #include <linux/slab.h>
diff --git a/drivers/gpu/drm/nouveau/nouveau_state.c b/drivers/gpu/drm/nouveau/nouveau_state.c
index 10656e4..e4cdddc 100644
--- a/drivers/gpu/drm/nouveau/nouveau_state.c
+++ b/drivers/gpu/drm/nouveau/nouveau_state.c
@@ -25,15 +25,15 @@
 
 #include <linux/swab.h>
 #include <linux/slab.h>
-#include "drmP.h"
-#include "drm.h"
-#include "drm_sarea.h"
-#include "drm_crtc_helper.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/drm_sarea.h>
+#include <drm/drm_crtc_helper.h>
 #include <linux/vgaarb.h>
 #include <linux/vga_switcheroo.h>
 
 #include "nouveau_drv.h"
-#include "nouveau_drm.h"
+#include <drm/nouveau_drm.h>
 #include "nouveau_fbcon.h"
 #include "nouveau_ramht.h"
 #include "nouveau_pm.h"
diff --git a/drivers/gpu/drm/nouveau/nouveau_temp.c b/drivers/gpu/drm/nouveau/nouveau_temp.c
index 081ca7b..27bc08e 100644
--- a/drivers/gpu/drm/nouveau/nouveau_temp.c
+++ b/drivers/gpu/drm/nouveau/nouveau_temp.c
@@ -22,7 +22,7 @@
  * Authors: Martin Peres
  */
 
-#include "drmP.h"
+#include <drm/drmP.h>
 
 #include "nouveau_drv.h"
 #include "nouveau_pm.h"
diff --git a/drivers/gpu/drm/nouveau/nouveau_ttm.c b/drivers/gpu/drm/nouveau/nouveau_ttm.c
index bd35f93..48de8dd 100644
--- a/drivers/gpu/drm/nouveau/nouveau_ttm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_ttm.c
@@ -24,7 +24,7 @@
  * USE OR OTHER DEALINGS IN THE SOFTWARE.
  */
 
-#include "drmP.h"
+#include <drm/drmP.h>
 
 #include "nouveau_drv.h"
 
diff --git a/drivers/gpu/drm/nouveau/nouveau_vm.c b/drivers/gpu/drm/nouveau/nouveau_vm.c
index 244fd38..6860ca8 100644
--- a/drivers/gpu/drm/nouveau/nouveau_vm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_vm.c
@@ -22,7 +22,7 @@
  * Authors: Ben Skeggs
  */
 
-#include "drmP.h"
+#include <drm/drmP.h>
 #include "nouveau_drv.h"
 #include "nouveau_mm.h"
 #include "nouveau_vm.h"
diff --git a/drivers/gpu/drm/nouveau/nouveau_vm.h b/drivers/gpu/drm/nouveau/nouveau_vm.h
index 579ca8c..b31d4a6 100644
--- a/drivers/gpu/drm/nouveau/nouveau_vm.h
+++ b/drivers/gpu/drm/nouveau/nouveau_vm.h
@@ -25,7 +25,7 @@
 #ifndef __NOUVEAU_VM_H__
 #define __NOUVEAU_VM_H__
 
-#include "drmP.h"
+#include <drm/drmP.h>
 
 #include "nouveau_drv.h"
 #include "nouveau_mm.h"
diff --git a/drivers/gpu/drm/nouveau/nouveau_volt.c b/drivers/gpu/drm/nouveau/nouveau_volt.c
index 75e87274..85c1287 100644
--- a/drivers/gpu/drm/nouveau/nouveau_volt.c
+++ b/drivers/gpu/drm/nouveau/nouveau_volt.c
@@ -22,7 +22,7 @@
  * Authors: Ben Skeggs
  */
 
-#include "drmP.h"
+#include <drm/drmP.h>
 
 #include "nouveau_drv.h"
 #include "nouveau_pm.h"
diff --git a/drivers/gpu/drm/nouveau/nv04_crtc.c b/drivers/gpu/drm/nouveau/nv04_crtc.c
index 118261d..92b789a 100644
--- a/drivers/gpu/drm/nouveau/nv04_crtc.c
+++ b/drivers/gpu/drm/nouveau/nv04_crtc.c
@@ -23,8 +23,8 @@
  * DEALINGS IN THE SOFTWARE.
  */
 
-#include "drmP.h"
-#include "drm_crtc_helper.h"
+#include <drm/drmP.h>
+#include <drm/drm_crtc_helper.h>
 
 #include "nouveau_drv.h"
 #include "nouveau_encoder.h"
diff --git a/drivers/gpu/drm/nouveau/nv04_cursor.c b/drivers/gpu/drm/nouveau/nv04_cursor.c
index aaf3de3..adadd2e 100644
--- a/drivers/gpu/drm/nouveau/nv04_cursor.c
+++ b/drivers/gpu/drm/nouveau/nv04_cursor.c
@@ -1,5 +1,5 @@
-#include "drmP.h"
-#include "drm_mode.h"
+#include <drm/drmP.h>
+#include <drm/drm_mode.h>
 #include "nouveau_reg.h"
 #include "nouveau_drv.h"
 #include "nouveau_crtc.h"
diff --git a/drivers/gpu/drm/nouveau/nv04_dac.c b/drivers/gpu/drm/nouveau/nv04_dac.c
index e000455..f8be357 100644
--- a/drivers/gpu/drm/nouveau/nv04_dac.c
+++ b/drivers/gpu/drm/nouveau/nv04_dac.c
@@ -24,8 +24,8 @@
  * DEALINGS IN THE SOFTWARE.
  */
 
-#include "drmP.h"
-#include "drm_crtc_helper.h"
+#include <drm/drmP.h>
+#include <drm/drm_crtc_helper.h>
 
 #include "nouveau_drv.h"
 #include "nouveau_encoder.h"
diff --git a/drivers/gpu/drm/nouveau/nv04_dfp.c b/drivers/gpu/drm/nouveau/nv04_dfp.c
index 12098bf..d657994 100644
--- a/drivers/gpu/drm/nouveau/nv04_dfp.c
+++ b/drivers/gpu/drm/nouveau/nv04_dfp.c
@@ -24,8 +24,8 @@
  * DEALINGS IN THE SOFTWARE.
  */
 
-#include "drmP.h"
-#include "drm_crtc_helper.h"
+#include <drm/drmP.h>
+#include <drm/drm_crtc_helper.h>
 
 #include "nouveau_drv.h"
 #include "nouveau_encoder.h"
@@ -34,7 +34,7 @@
 #include "nouveau_hw.h"
 #include "nvreg.h"
 
-#include "i2c/sil164.h"
+#include <drm/i2c/sil164.h>
 
 #define FP_TG_CONTROL_ON  (NV_PRAMDAC_FP_TG_CONTROL_DISPEN_POS |	\
 			   NV_PRAMDAC_FP_TG_CONTROL_HSYNC_POS |		\
diff --git a/drivers/gpu/drm/nouveau/nv04_display.c b/drivers/gpu/drm/nouveau/nv04_display.c
index 1715e14..cdaf221 100644
--- a/drivers/gpu/drm/nouveau/nv04_display.c
+++ b/drivers/gpu/drm/nouveau/nv04_display.c
@@ -22,9 +22,9 @@
  * Author: Ben Skeggs
  */
 
-#include "drmP.h"
-#include "drm.h"
-#include "drm_crtc_helper.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/drm_crtc_helper.h>
 
 #include "nouveau_drv.h"
 #include "nouveau_fb.h"
diff --git a/drivers/gpu/drm/nouveau/nv04_fb.c b/drivers/gpu/drm/nouveau/nv04_fb.c
index 638cf60..7ab03bd 100644
--- a/drivers/gpu/drm/nouveau/nv04_fb.c
+++ b/drivers/gpu/drm/nouveau/nv04_fb.c
@@ -1,7 +1,7 @@
-#include "drmP.h"
-#include "drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
 #include "nouveau_drv.h"
-#include "nouveau_drm.h"
+#include <drm/nouveau_drm.h>
 
 int
 nv04_fb_init(struct drm_device *dev)
diff --git a/drivers/gpu/drm/nouveau/nv04_fbcon.c b/drivers/gpu/drm/nouveau/nv04_fbcon.c
index 7a11893..8edd9f8 100644
--- a/drivers/gpu/drm/nouveau/nv04_fbcon.c
+++ b/drivers/gpu/drm/nouveau/nv04_fbcon.c
@@ -22,7 +22,7 @@
  * DEALINGS IN THE SOFTWARE.
  */
 
-#include "drmP.h"
+#include <drm/drmP.h>
 #include "nouveau_drv.h"
 #include "nouveau_dma.h"
 #include "nouveau_ramht.h"
diff --git a/drivers/gpu/drm/nouveau/nv04_fifo.c b/drivers/gpu/drm/nouveau/nv04_fifo.c
index db465a3..74e7036 100644
--- a/drivers/gpu/drm/nouveau/nv04_fifo.c
+++ b/drivers/gpu/drm/nouveau/nv04_fifo.c
@@ -24,8 +24,8 @@
  *
  */
 
-#include "drmP.h"
-#include "drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
 #include "nouveau_drv.h"
 #include "nouveau_ramht.h"
 #include "nouveau_util.h"
diff --git a/drivers/gpu/drm/nouveau/nv04_graph.c b/drivers/gpu/drm/nouveau/nv04_graph.c
index dbdea8e..b9c7711 100644
--- a/drivers/gpu/drm/nouveau/nv04_graph.c
+++ b/drivers/gpu/drm/nouveau/nv04_graph.c
@@ -22,9 +22,9 @@
  * DEALINGS IN THE SOFTWARE.
  */
 
-#include "drmP.h"
-#include "drm.h"
-#include "nouveau_drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/nouveau_drm.h>
 #include "nouveau_drv.h"
 #include "nouveau_hw.h"
 #include "nouveau_util.h"
diff --git a/drivers/gpu/drm/nouveau/nv04_instmem.c b/drivers/gpu/drm/nouveau/nv04_instmem.c
index c1248e0..19c0c8f 100644
--- a/drivers/gpu/drm/nouveau/nv04_instmem.c
+++ b/drivers/gpu/drm/nouveau/nv04_instmem.c
@@ -1,5 +1,5 @@
-#include "drmP.h"
-#include "drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
 #include "nouveau_drv.h"
 #include "nouveau_ramht.h"
 
diff --git a/drivers/gpu/drm/nouveau/nv04_mc.c b/drivers/gpu/drm/nouveau/nv04_mc.c
index 2af43a1..2a86392 100644
--- a/drivers/gpu/drm/nouveau/nv04_mc.c
+++ b/drivers/gpu/drm/nouveau/nv04_mc.c
@@ -1,7 +1,7 @@
-#include "drmP.h"
-#include "drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
 #include "nouveau_drv.h"
-#include "nouveau_drm.h"
+#include <drm/nouveau_drm.h>
 
 int
 nv04_mc_init(struct drm_device *dev)
diff --git a/drivers/gpu/drm/nouveau/nv04_pm.c b/drivers/gpu/drm/nouveau/nv04_pm.c
index eb1c70d..fdced80 100644
--- a/drivers/gpu/drm/nouveau/nv04_pm.c
+++ b/drivers/gpu/drm/nouveau/nv04_pm.c
@@ -22,7 +22,7 @@
  * Authors: Ben Skeggs
  */
 
-#include "drmP.h"
+#include <drm/drmP.h>
 #include "nouveau_drv.h"
 #include "nouveau_hw.h"
 #include "nouveau_pm.h"
diff --git a/drivers/gpu/drm/nouveau/nv04_timer.c b/drivers/gpu/drm/nouveau/nv04_timer.c
index 1d09ddd..accd70c 100644
--- a/drivers/gpu/drm/nouveau/nv04_timer.c
+++ b/drivers/gpu/drm/nouveau/nv04_timer.c
@@ -1,7 +1,7 @@
-#include "drmP.h"
-#include "drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
 #include "nouveau_drv.h"
-#include "nouveau_drm.h"
+#include <drm/nouveau_drm.h>
 
 int
 nv04_timer_init(struct drm_device *dev)
diff --git a/drivers/gpu/drm/nouveau/nv04_tv.c b/drivers/gpu/drm/nouveau/nv04_tv.c
index 3eb605d..7157d40 100644
--- a/drivers/gpu/drm/nouveau/nv04_tv.c
+++ b/drivers/gpu/drm/nouveau/nv04_tv.c
@@ -24,15 +24,15 @@
  *
  */
 
-#include "drmP.h"
+#include <drm/drmP.h>
 #include "nouveau_drv.h"
 #include "nouveau_encoder.h"
 #include "nouveau_connector.h"
 #include "nouveau_crtc.h"
 #include "nouveau_hw.h"
-#include "drm_crtc_helper.h"
+#include <drm/drm_crtc_helper.h>
 
-#include "i2c/ch7006.h"
+#include <drm/i2c/ch7006.h>
 
 static struct i2c_board_info nv04_tv_encoder_info[] = {
 	{
diff --git a/drivers/gpu/drm/nouveau/nv10_fb.c b/drivers/gpu/drm/nouveau/nv10_fb.c
index f78181a..7bea13d 100644
--- a/drivers/gpu/drm/nouveau/nv10_fb.c
+++ b/drivers/gpu/drm/nouveau/nv10_fb.c
@@ -1,7 +1,7 @@
-#include "drmP.h"
-#include "drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
 #include "nouveau_drv.h"
-#include "nouveau_drm.h"
+#include <drm/nouveau_drm.h>
 
 static struct drm_mm_node *
 nv20_fb_alloc_tag(struct drm_device *dev, uint32_t size)
diff --git a/drivers/gpu/drm/nouveau/nv10_fifo.c b/drivers/gpu/drm/nouveau/nv10_fifo.c
index d2ecbff..1d8daf0d 100644
--- a/drivers/gpu/drm/nouveau/nv10_fifo.c
+++ b/drivers/gpu/drm/nouveau/nv10_fifo.c
@@ -24,8 +24,8 @@
  *
  */
 
-#include "drmP.h"
-#include "drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
 #include "nouveau_drv.h"
 #include "nouveau_ramht.h"
 
diff --git a/drivers/gpu/drm/nouveau/nv10_gpio.c b/drivers/gpu/drm/nouveau/nv10_gpio.c
index 007fc29..783cc8d 100644
--- a/drivers/gpu/drm/nouveau/nv10_gpio.c
+++ b/drivers/gpu/drm/nouveau/nv10_gpio.c
@@ -24,7 +24,7 @@
  *
  */
 
-#include "drmP.h"
+#include <drm/drmP.h>
 #include "nouveau_drv.h"
 #include "nouveau_hw.h"
 
diff --git a/drivers/gpu/drm/nouveau/nv10_graph.c b/drivers/gpu/drm/nouveau/nv10_graph.c
index 7255e4a..b0afa5c 100644
--- a/drivers/gpu/drm/nouveau/nv10_graph.c
+++ b/drivers/gpu/drm/nouveau/nv10_graph.c
@@ -22,9 +22,9 @@
  * DEALINGS IN THE SOFTWARE.
  */
 
-#include "drmP.h"
-#include "drm.h"
-#include "nouveau_drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/nouveau_drm.h>
 #include "nouveau_drv.h"
 #include "nouveau_util.h"
 
diff --git a/drivers/gpu/drm/nouveau/nv17_tv.c b/drivers/gpu/drm/nouveau/nv17_tv.c
index 3900ceb..1de088d 100644
--- a/drivers/gpu/drm/nouveau/nv17_tv.c
+++ b/drivers/gpu/drm/nouveau/nv17_tv.c
@@ -24,8 +24,8 @@
  *
  */
 
-#include "drmP.h"
-#include "drm_crtc_helper.h"
+#include <drm/drmP.h>
+#include <drm/drm_crtc_helper.h>
 #include "nouveau_drv.h"
 #include "nouveau_encoder.h"
 #include "nouveau_connector.h"
diff --git a/drivers/gpu/drm/nouveau/nv17_tv_modes.c b/drivers/gpu/drm/nouveau/nv17_tv_modes.c
index 4d1d29f..96e4286 100644
--- a/drivers/gpu/drm/nouveau/nv17_tv_modes.c
+++ b/drivers/gpu/drm/nouveau/nv17_tv_modes.c
@@ -24,8 +24,8 @@
  *
  */
 
-#include "drmP.h"
-#include "drm_crtc_helper.h"
+#include <drm/drmP.h>
+#include <drm/drm_crtc_helper.h>
 #include "nouveau_drv.h"
 #include "nouveau_encoder.h"
 #include "nouveau_crtc.h"
diff --git a/drivers/gpu/drm/nouveau/nv20_graph.c b/drivers/gpu/drm/nouveau/nv20_graph.c
index 183e375..80c9a0f 100644
--- a/drivers/gpu/drm/nouveau/nv20_graph.c
+++ b/drivers/gpu/drm/nouveau/nv20_graph.c
@@ -1,7 +1,7 @@
-#include "drmP.h"
-#include "drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
 #include "nouveau_drv.h"
-#include "nouveau_drm.h"
+#include <drm/nouveau_drm.h>
 
 /*
  * NV20
diff --git a/drivers/gpu/drm/nouveau/nv30_fb.c b/drivers/gpu/drm/nouveau/nv30_fb.c
index e0135f0..46a5105 100644
--- a/drivers/gpu/drm/nouveau/nv30_fb.c
+++ b/drivers/gpu/drm/nouveau/nv30_fb.c
@@ -24,10 +24,10 @@
  *
  */
 
-#include "drmP.h"
-#include "drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
 #include "nouveau_drv.h"
-#include "nouveau_drm.h"
+#include <drm/nouveau_drm.h>
 
 void
 nv30_fb_init_tile_region(struct drm_device *dev, int i, uint32_t addr,
diff --git a/drivers/gpu/drm/nouveau/nv40_fb.c b/drivers/gpu/drm/nouveau/nv40_fb.c
index f0ac2a7..70780b0 100644
--- a/drivers/gpu/drm/nouveau/nv40_fb.c
+++ b/drivers/gpu/drm/nouveau/nv40_fb.c
@@ -1,7 +1,7 @@
-#include "drmP.h"
-#include "drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
 #include "nouveau_drv.h"
-#include "nouveau_drm.h"
+#include <drm/nouveau_drm.h>
 
 void
 nv40_fb_set_tile_region(struct drm_device *dev, int i)
diff --git a/drivers/gpu/drm/nouveau/nv40_fifo.c b/drivers/gpu/drm/nouveau/nv40_fifo.c
index 68cb2d9..391a34e 100644
--- a/drivers/gpu/drm/nouveau/nv40_fifo.c
+++ b/drivers/gpu/drm/nouveau/nv40_fifo.c
@@ -24,9 +24,9 @@
  *
  */
 
-#include "drmP.h"
+#include <drm/drmP.h>
 #include "nouveau_drv.h"
-#include "nouveau_drm.h"
+#include <drm/nouveau_drm.h>
 #include "nouveau_ramht.h"
 
 #define NV40_RAMFC(c) (dev_priv->ramfc->pinst + ((c) * NV40_RAMFC__SIZE))
diff --git a/drivers/gpu/drm/nouveau/nv40_graph.c b/drivers/gpu/drm/nouveau/nv40_graph.c
index ba14a93..ce6b850 100644
--- a/drivers/gpu/drm/nouveau/nv40_graph.c
+++ b/drivers/gpu/drm/nouveau/nv40_graph.c
@@ -24,8 +24,8 @@
  *
  */
 
-#include "drmP.h"
-#include "drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
 #include "nouveau_drv.h"
 #include "nouveau_grctx.h"
 #include "nouveau_ramht.h"
diff --git a/drivers/gpu/drm/nouveau/nv40_grctx.c b/drivers/gpu/drm/nouveau/nv40_grctx.c
index f70447d..d696a81 100644
--- a/drivers/gpu/drm/nouveau/nv40_grctx.c
+++ b/drivers/gpu/drm/nouveau/nv40_grctx.c
@@ -109,7 +109,7 @@
 #define CP_LOAD_MAGIC_NV44TCL    0x00800029 /* per-vs state (0x4497) */
 #define CP_LOAD_MAGIC_NV40TCL    0x00800041 /* per-vs state (0x4097) */
 
-#include "drmP.h"
+#include <drm/drmP.h>
 #include "nouveau_drv.h"
 #include "nouveau_grctx.h"
 
diff --git a/drivers/gpu/drm/nouveau/nv40_mc.c b/drivers/gpu/drm/nouveau/nv40_mc.c
index 03c0d4c..7af9185 100644
--- a/drivers/gpu/drm/nouveau/nv40_mc.c
+++ b/drivers/gpu/drm/nouveau/nv40_mc.c
@@ -1,7 +1,7 @@
-#include "drmP.h"
-#include "drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
 #include "nouveau_drv.h"
-#include "nouveau_drm.h"
+#include <drm/nouveau_drm.h>
 
 int
 nv40_mc_init(struct drm_device *dev)
diff --git a/drivers/gpu/drm/nouveau/nv40_mpeg.c b/drivers/gpu/drm/nouveau/nv40_mpeg.c
index ad03a0e..5de3a39 100644
--- a/drivers/gpu/drm/nouveau/nv40_mpeg.c
+++ b/drivers/gpu/drm/nouveau/nv40_mpeg.c
@@ -22,7 +22,7 @@
  * Authors: Ben Skeggs
  */
 
-#include "drmP.h"
+#include <drm/drmP.h>
 #include "nouveau_drv.h"
 #include "nouveau_ramht.h"
 
diff --git a/drivers/gpu/drm/nouveau/nv50_calc.c b/drivers/gpu/drm/nouveau/nv50_calc.c
index 8cf63a8..4d019eb 100644
--- a/drivers/gpu/drm/nouveau/nv50_calc.c
+++ b/drivers/gpu/drm/nouveau/nv50_calc.c
@@ -22,7 +22,7 @@
  * Authors: Ben Skeggs
  */
 
-#include "drmP.h"
+#include <drm/drmP.h>
 #include "nouveau_drv.h"
 #include "nouveau_hw.h"
 
diff --git a/drivers/gpu/drm/nouveau/nv50_crtc.c b/drivers/gpu/drm/nouveau/nv50_crtc.c
index 46ad59e..23a97a9 100644
--- a/drivers/gpu/drm/nouveau/nv50_crtc.c
+++ b/drivers/gpu/drm/nouveau/nv50_crtc.c
@@ -24,9 +24,9 @@
  *
  */
 
-#include "drmP.h"
-#include "drm_mode.h"
-#include "drm_crtc_helper.h"
+#include <drm/drmP.h>
+#include <drm/drm_mode.h>
+#include <drm/drm_crtc_helper.h>
 
 #define NOUVEAU_DMA_DEBUG (nouveau_reg_debug & NOUVEAU_REG_DEBUG_EVO)
 #include "nouveau_reg.h"
diff --git a/drivers/gpu/drm/nouveau/nv50_cursor.c b/drivers/gpu/drm/nouveau/nv50_cursor.c
index 9752c35..f23f9ef 100644
--- a/drivers/gpu/drm/nouveau/nv50_cursor.c
+++ b/drivers/gpu/drm/nouveau/nv50_cursor.c
@@ -24,8 +24,8 @@
  *
  */
 
-#include "drmP.h"
-#include "drm_mode.h"
+#include <drm/drmP.h>
+#include <drm/drm_mode.h>
 
 #define NOUVEAU_DMA_DEBUG (nouveau_reg_debug & NOUVEAU_REG_DEBUG_EVO)
 #include "nouveau_reg.h"
diff --git a/drivers/gpu/drm/nouveau/nv50_dac.c b/drivers/gpu/drm/nouveau/nv50_dac.c
index 808f3ec..d2bc3f8 100644
--- a/drivers/gpu/drm/nouveau/nv50_dac.c
+++ b/drivers/gpu/drm/nouveau/nv50_dac.c
@@ -24,8 +24,8 @@
  *
  */
 
-#include "drmP.h"
-#include "drm_crtc_helper.h"
+#include <drm/drmP.h>
+#include <drm/drm_crtc_helper.h>
 
 #define NOUVEAU_DMA_DEBUG (nouveau_reg_debug & NOUVEAU_REG_DEBUG_EVO)
 #include "nouveau_reg.h"
diff --git a/drivers/gpu/drm/nouveau/nv50_display.c b/drivers/gpu/drm/nouveau/nv50_display.c
index db1a5f4..ffdc35a 100644
--- a/drivers/gpu/drm/nouveau/nv50_display.c
+++ b/drivers/gpu/drm/nouveau/nv50_display.c
@@ -32,7 +32,7 @@
 #include "nouveau_fb.h"
 #include "nouveau_fbcon.h"
 #include "nouveau_ramht.h"
-#include "drm_crtc_helper.h"
+#include <drm/drm_crtc_helper.h>
 
 static void nv50_display_isr(struct drm_device *);
 static void nv50_display_bh(unsigned long);
diff --git a/drivers/gpu/drm/nouveau/nv50_display.h b/drivers/gpu/drm/nouveau/nv50_display.h
index c2da503..cfaa1c5 100644
--- a/drivers/gpu/drm/nouveau/nv50_display.h
+++ b/drivers/gpu/drm/nouveau/nv50_display.h
@@ -27,8 +27,8 @@
 #ifndef __NV50_DISPLAY_H__
 #define __NV50_DISPLAY_H__
 
-#include "drmP.h"
-#include "drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
 #include "nouveau_drv.h"
 #include "nouveau_dma.h"
 #include "nouveau_reg.h"
diff --git a/drivers/gpu/drm/nouveau/nv50_evo.c b/drivers/gpu/drm/nouveau/nv50_evo.c
index c99d975..ce0ac9f 100644
--- a/drivers/gpu/drm/nouveau/nv50_evo.c
+++ b/drivers/gpu/drm/nouveau/nv50_evo.c
@@ -22,7 +22,7 @@
  * Authors: Ben Skeggs
  */
 
-#include "drmP.h"
+#include <drm/drmP.h>
 
 #include "nouveau_drv.h"
 #include "nouveau_dma.h"
diff --git a/drivers/gpu/drm/nouveau/nv50_fb.c b/drivers/gpu/drm/nouveau/nv50_fb.c
index bdd2afe..e49c3d7 100644
--- a/drivers/gpu/drm/nouveau/nv50_fb.c
+++ b/drivers/gpu/drm/nouveau/nv50_fb.c
@@ -1,7 +1,7 @@
-#include "drmP.h"
-#include "drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
 #include "nouveau_drv.h"
-#include "nouveau_drm.h"
+#include <drm/nouveau_drm.h>
 
 struct nv50_fb_priv {
 	struct page *r100c08_page;
diff --git a/drivers/gpu/drm/nouveau/nv50_fbcon.c b/drivers/gpu/drm/nouveau/nv50_fbcon.c
index dc75a72..5ad1cf7 100644
--- a/drivers/gpu/drm/nouveau/nv50_fbcon.c
+++ b/drivers/gpu/drm/nouveau/nv50_fbcon.c
@@ -22,7 +22,7 @@
  * Authors: Ben Skeggs
  */
 
-#include "drmP.h"
+#include <drm/drmP.h>
 #include "nouveau_drv.h"
 #include "nouveau_dma.h"
 #include "nouveau_ramht.h"
diff --git a/drivers/gpu/drm/nouveau/nv50_fifo.c b/drivers/gpu/drm/nouveau/nv50_fifo.c
index c34a074..e4f9426 100644
--- a/drivers/gpu/drm/nouveau/nv50_fifo.c
+++ b/drivers/gpu/drm/nouveau/nv50_fifo.c
@@ -24,8 +24,8 @@
  *
  */
 
-#include "drmP.h"
-#include "drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
 #include "nouveau_drv.h"
 #include "nouveau_ramht.h"
 #include "nouveau_vm.h"
diff --git a/drivers/gpu/drm/nouveau/nv50_gpio.c b/drivers/gpu/drm/nouveau/nv50_gpio.c
index d4f4206..c91ec9c 100644
--- a/drivers/gpu/drm/nouveau/nv50_gpio.c
+++ b/drivers/gpu/drm/nouveau/nv50_gpio.c
@@ -22,7 +22,7 @@
  * Authors: Ben Skeggs
  */
 
-#include "drmP.h"
+#include <drm/drmP.h>
 #include "nouveau_drv.h"
 #include "nouveau_hw.h"
 
diff --git a/drivers/gpu/drm/nouveau/nv50_graph.c b/drivers/gpu/drm/nouveau/nv50_graph.c
index d43c46c..e248097 100644
--- a/drivers/gpu/drm/nouveau/nv50_graph.c
+++ b/drivers/gpu/drm/nouveau/nv50_graph.c
@@ -24,8 +24,8 @@
  *
  */
 
-#include "drmP.h"
-#include "drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
 #include "nouveau_drv.h"
 #include "nouveau_ramht.h"
 #include "nouveau_grctx.h"
diff --git a/drivers/gpu/drm/nouveau/nv50_grctx.c b/drivers/gpu/drm/nouveau/nv50_grctx.c
index de9abff..4e6c010 100644
--- a/drivers/gpu/drm/nouveau/nv50_grctx.c
+++ b/drivers/gpu/drm/nouveau/nv50_grctx.c
@@ -99,7 +99,7 @@
 #define CP_SEEK_1      0x00c000ff
 #define CP_SEEK_2      0x00c800ff
 
-#include "drmP.h"
+#include <drm/drmP.h>
 #include "nouveau_drv.h"
 #include "nouveau_grctx.h"
 
diff --git a/drivers/gpu/drm/nouveau/nv50_instmem.c b/drivers/gpu/drm/nouveau/nv50_instmem.c
index a7c12c9..5236163 100644
--- a/drivers/gpu/drm/nouveau/nv50_instmem.c
+++ b/drivers/gpu/drm/nouveau/nv50_instmem.c
@@ -25,8 +25,8 @@
  *
  */
 
-#include "drmP.h"
-#include "drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
 
 #include "nouveau_drv.h"
 #include "nouveau_vm.h"
diff --git a/drivers/gpu/drm/nouveau/nv50_mc.c b/drivers/gpu/drm/nouveau/nv50_mc.c
index e0a9c3f..b3d0af9 100644
--- a/drivers/gpu/drm/nouveau/nv50_mc.c
+++ b/drivers/gpu/drm/nouveau/nv50_mc.c
@@ -24,8 +24,8 @@
  *
  */
 
-#include "drmP.h"
-#include "drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
 #include "nouveau_drv.h"
 
 int
diff --git a/drivers/gpu/drm/nouveau/nv50_mpeg.c b/drivers/gpu/drm/nouveau/nv50_mpeg.c
index b57a2d1..aecccd3 100644
--- a/drivers/gpu/drm/nouveau/nv50_mpeg.c
+++ b/drivers/gpu/drm/nouveau/nv50_mpeg.c
@@ -22,7 +22,7 @@
  * Authors: Ben Skeggs
  */
 
-#include "drmP.h"
+#include <drm/drmP.h>
 #include "nouveau_drv.h"
 #include "nouveau_ramht.h"
 
diff --git a/drivers/gpu/drm/nouveau/nv50_pm.c b/drivers/gpu/drm/nouveau/nv50_pm.c
index 8a28100..5e5af77 100644
--- a/drivers/gpu/drm/nouveau/nv50_pm.c
+++ b/drivers/gpu/drm/nouveau/nv50_pm.c
@@ -22,7 +22,7 @@
  * Authors: Ben Skeggs
  */
 
-#include "drmP.h"
+#include <drm/drmP.h>
 #include "nouveau_drv.h"
 #include "nouveau_bios.h"
 #include "nouveau_pm.h"
diff --git a/drivers/gpu/drm/nouveau/nv50_sor.c b/drivers/gpu/drm/nouveau/nv50_sor.c
index ffe8b48..95da9e9 100644
--- a/drivers/gpu/drm/nouveau/nv50_sor.c
+++ b/drivers/gpu/drm/nouveau/nv50_sor.c
@@ -24,8 +24,8 @@
  *
  */
 
-#include "drmP.h"
-#include "drm_crtc_helper.h"
+#include <drm/drmP.h>
+#include <drm/drm_crtc_helper.h>
 
 #define NOUVEAU_DMA_DEBUG (nouveau_reg_debug & NOUVEAU_REG_DEBUG_EVO)
 #include "nouveau_reg.h"
diff --git a/drivers/gpu/drm/nouveau/nv50_vm.c b/drivers/gpu/drm/nouveau/nv50_vm.c
index 40b84f2..43ddaf3 100644
--- a/drivers/gpu/drm/nouveau/nv50_vm.c
+++ b/drivers/gpu/drm/nouveau/nv50_vm.c
@@ -22,7 +22,7 @@
  * Authors: Ben Skeggs
  */
 
-#include "drmP.h"
+#include <drm/drmP.h>
 
 #include "nouveau_drv.h"
 #include "nouveau_vm.h"
diff --git a/drivers/gpu/drm/nouveau/nv50_vram.c b/drivers/gpu/drm/nouveau/nv50_vram.c
index af32dae..0d48780 100644
--- a/drivers/gpu/drm/nouveau/nv50_vram.c
+++ b/drivers/gpu/drm/nouveau/nv50_vram.c
@@ -22,7 +22,7 @@
  * Authors: Ben Skeggs
  */
 
-#include "drmP.h"
+#include <drm/drmP.h>
 #include "nouveau_drv.h"
 #include "nouveau_mm.h"
 
diff --git a/drivers/gpu/drm/nouveau/nv84_crypt.c b/drivers/gpu/drm/nouveau/nv84_crypt.c
index edece9c..c986439 100644
--- a/drivers/gpu/drm/nouveau/nv84_crypt.c
+++ b/drivers/gpu/drm/nouveau/nv84_crypt.c
@@ -22,7 +22,7 @@
  * Authors: Ben Skeggs
  */
 
-#include "drmP.h"
+#include <drm/drmP.h>
 #include "nouveau_drv.h"
 #include "nouveau_util.h"
 #include "nouveau_vm.h"
diff --git a/drivers/gpu/drm/nouveau/nva3_copy.c b/drivers/gpu/drm/nouveau/nva3_copy.c
index 8f356d5..638f79f 100644
--- a/drivers/gpu/drm/nouveau/nva3_copy.c
+++ b/drivers/gpu/drm/nouveau/nva3_copy.c
@@ -23,7 +23,7 @@
  */
 
 #include <linux/firmware.h>
-#include "drmP.h"
+#include <drm/drmP.h>
 #include "nouveau_drv.h"
 #include "nouveau_util.h"
 #include "nouveau_vm.h"
diff --git a/drivers/gpu/drm/nouveau/nva3_pm.c b/drivers/gpu/drm/nouveau/nva3_pm.c
index e4b2b9e..8f69f91 100644
--- a/drivers/gpu/drm/nouveau/nva3_pm.c
+++ b/drivers/gpu/drm/nouveau/nva3_pm.c
@@ -22,7 +22,7 @@
  * Authors: Ben Skeggs
  */
 
-#include "drmP.h"
+#include <drm/drmP.h>
 #include "nouveau_drv.h"
 #include "nouveau_bios.h"
 #include "nouveau_pm.h"
diff --git a/drivers/gpu/drm/nouveau/nvc0_copy.c b/drivers/gpu/drm/nouveau/nvc0_copy.c
index dddf006..88a922d 100644
--- a/drivers/gpu/drm/nouveau/nvc0_copy.c
+++ b/drivers/gpu/drm/nouveau/nvc0_copy.c
@@ -23,7 +23,7 @@
  */
 
 #include <linux/firmware.h>
-#include "drmP.h"
+#include <drm/drmP.h>
 #include "nouveau_drv.h"
 #include "nouveau_util.h"
 #include "nouveau_vm.h"
diff --git a/drivers/gpu/drm/nouveau/nvc0_fb.c b/drivers/gpu/drm/nouveau/nvc0_fb.c
index 08e6b11..34b65ed 100644
--- a/drivers/gpu/drm/nouveau/nvc0_fb.c
+++ b/drivers/gpu/drm/nouveau/nvc0_fb.c
@@ -22,10 +22,10 @@
  * Authors: Ben Skeggs
  */
 
-#include "drmP.h"
-#include "drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
 #include "nouveau_drv.h"
-#include "nouveau_drm.h"
+#include <drm/nouveau_drm.h>
 
 struct nvc0_fb_priv {
 	struct page *r100c10_page;
diff --git a/drivers/gpu/drm/nouveau/nvc0_fbcon.c b/drivers/gpu/drm/nouveau/nvc0_fbcon.c
index a495e48..979d136 100644
--- a/drivers/gpu/drm/nouveau/nvc0_fbcon.c
+++ b/drivers/gpu/drm/nouveau/nvc0_fbcon.c
@@ -22,7 +22,7 @@
  * Authors: Ben Skeggs
  */
 
-#include "drmP.h"
+#include <drm/drmP.h>
 #include "nouveau_drv.h"
 #include "nouveau_dma.h"
 #include "nouveau_ramht.h"
diff --git a/drivers/gpu/drm/nouveau/nvc0_fifo.c b/drivers/gpu/drm/nouveau/nvc0_fifo.c
index 6f9f341..03f7691 100644
--- a/drivers/gpu/drm/nouveau/nvc0_fifo.c
+++ b/drivers/gpu/drm/nouveau/nvc0_fifo.c
@@ -22,7 +22,7 @@
  * Authors: Ben Skeggs
  */
 
-#include "drmP.h"
+#include <drm/drmP.h>
 
 #include "nouveau_drv.h"
 #include "nouveau_mm.h"
diff --git a/drivers/gpu/drm/nouveau/nvc0_graph.c b/drivers/gpu/drm/nouveau/nvc0_graph.c
index 5b2f6f4..a546d4f 100644
--- a/drivers/gpu/drm/nouveau/nvc0_graph.c
+++ b/drivers/gpu/drm/nouveau/nvc0_graph.c
@@ -24,7 +24,7 @@
 
 #include <linux/firmware.h>
 
-#include "drmP.h"
+#include <drm/drmP.h>
 
 #include "nouveau_drv.h"
 #include "nouveau_mm.h"
diff --git a/drivers/gpu/drm/nouveau/nvc0_grctx.c b/drivers/gpu/drm/nouveau/nvc0_grctx.c
index 31018ea..78ea165 100644
--- a/drivers/gpu/drm/nouveau/nvc0_grctx.c
+++ b/drivers/gpu/drm/nouveau/nvc0_grctx.c
@@ -22,7 +22,7 @@
  * Authors: Ben Skeggs
  */
 
-#include "drmP.h"
+#include <drm/drmP.h>
 #include "nouveau_drv.h"
 #include "nouveau_mm.h"
 #include "nvc0_graph.h"
diff --git a/drivers/gpu/drm/nouveau/nvc0_instmem.c b/drivers/gpu/drm/nouveau/nvc0_instmem.c
index b701c43..f5fac7c 100644
--- a/drivers/gpu/drm/nouveau/nvc0_instmem.c
+++ b/drivers/gpu/drm/nouveau/nvc0_instmem.c
@@ -22,7 +22,7 @@
  * Authors: Ben Skeggs
  */
 
-#include "drmP.h"
+#include <drm/drmP.h>
 
 #include "nouveau_drv.h"
 #include "nouveau_vm.h"
diff --git a/drivers/gpu/drm/nouveau/nvc0_vm.c b/drivers/gpu/drm/nouveau/nvc0_vm.c
index 9e35294..3ba6109 100644
--- a/drivers/gpu/drm/nouveau/nvc0_vm.c
+++ b/drivers/gpu/drm/nouveau/nvc0_vm.c
@@ -22,7 +22,7 @@
  * Authors: Ben Skeggs
  */
 
-#include "drmP.h"
+#include <drm/drmP.h>
 
 #include "nouveau_drv.h"
 #include "nouveau_vm.h"
diff --git a/drivers/gpu/drm/nouveau/nvc0_vram.c b/drivers/gpu/drm/nouveau/nvc0_vram.c
index e45a24d..da1a49f 100644
--- a/drivers/gpu/drm/nouveau/nvc0_vram.c
+++ b/drivers/gpu/drm/nouveau/nvc0_vram.c
@@ -22,7 +22,7 @@
  * Authors: Ben Skeggs
  */
 
-#include "drmP.h"
+#include <drm/drmP.h>
 #include "nouveau_drv.h"
 #include "nouveau_mm.h"
 
diff --git a/drivers/gpu/drm/r128/r128_cce.c b/drivers/gpu/drm/r128/r128_cce.c
index 570e190..dfd67f2 100644
--- a/drivers/gpu/drm/r128/r128_cce.c
+++ b/drivers/gpu/drm/r128/r128_cce.c
@@ -33,9 +33,9 @@
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 
-#include "drmP.h"
-#include "drm.h"
-#include "r128_drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/r128_drm.h>
 #include "r128_drv.h"
 
 #define R128_FIFO_DEBUG		0
diff --git a/drivers/gpu/drm/r128/r128_drv.c b/drivers/gpu/drm/r128/r128_drv.c
index b9e8efd..af68cad 100644
--- a/drivers/gpu/drm/r128/r128_drv.c
+++ b/drivers/gpu/drm/r128/r128_drv.c
@@ -29,12 +29,12 @@
  *    Gareth Hughes <gareth@valinux.com>
  */
 
-#include "drmP.h"
-#include "drm.h"
-#include "r128_drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/r128_drm.h>
 #include "r128_drv.h"
 
-#include "drm_pciids.h"
+#include <drm/drm_pciids.h>
 
 static struct pci_device_id pciidlist[] = {
 	r128_PCI_IDS
diff --git a/drivers/gpu/drm/r128/r128_ioc32.c b/drivers/gpu/drm/r128/r128_ioc32.c
index 51c99fc..d70d4f6 100644
--- a/drivers/gpu/drm/r128/r128_ioc32.c
+++ b/drivers/gpu/drm/r128/r128_ioc32.c
@@ -31,9 +31,9 @@
  */
 #include <linux/compat.h>
 
-#include "drmP.h"
-#include "drm.h"
-#include "r128_drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/r128_drm.h>
 
 typedef struct drm_r128_init32 {
 	int func;
diff --git a/drivers/gpu/drm/r128/r128_irq.c b/drivers/gpu/drm/r128/r128_irq.c
index 429d5a0..7d285b3 100644
--- a/drivers/gpu/drm/r128/r128_irq.c
+++ b/drivers/gpu/drm/r128/r128_irq.c
@@ -30,9 +30,9 @@
  *    Eric Anholt <anholt@FreeBSD.org>
  */
 
-#include "drmP.h"
-#include "drm.h"
-#include "r128_drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/r128_drm.h>
 #include "r128_drv.h"
 
 u32 r128_get_vblank_counter(struct drm_device *dev, int crtc)
diff --git a/drivers/gpu/drm/r128/r128_state.c b/drivers/gpu/drm/r128/r128_state.c
index a9e33ce..bf91739 100644
--- a/drivers/gpu/drm/r128/r128_state.c
+++ b/drivers/gpu/drm/r128/r128_state.c
@@ -28,9 +28,9 @@
  *    Gareth Hughes <gareth@valinux.com>
  */
 
-#include "drmP.h"
-#include "drm.h"
-#include "r128_drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/r128_drm.h>
 #include "r128_drv.h"
 
 /* ================================================================
diff --git a/drivers/gpu/drm/radeon/atom.h b/drivers/gpu/drm/radeon/atom.h
index a589a55..8da1659 100644
--- a/drivers/gpu/drm/radeon/atom.h
+++ b/drivers/gpu/drm/radeon/atom.h
@@ -26,7 +26,7 @@
 #define ATOM_H
 
 #include <linux/types.h>
-#include "drmP.h"
+#include <drm/drmP.h>
 
 #define ATOM_BIOS_MAGIC		0xAA55
 #define ATOM_ATI_MAGIC_PTR	0x30
diff --git a/drivers/gpu/drm/radeon/atombios_dp.c b/drivers/gpu/drm/radeon/atombios_dp.c
index 645b84b..83da0af 100644
--- a/drivers/gpu/drm/radeon/atombios_dp.c
+++ b/drivers/gpu/drm/radeon/atombios_dp.c
@@ -23,13 +23,13 @@
  * Authors: Dave Airlie
  *          Alex Deucher
  */
-#include "drmP.h"
-#include "radeon_drm.h"
+#include <drm/drmP.h>
+#include <drm/radeon_drm.h>
 #include "radeon.h"
 
 #include "atom.h"
 #include "atom-bits.h"
-#include "drm_dp_helper.h"
+#include <drm/drm_dp_helper.h>
 
 /* move these to drm_dp_helper.c/h */
 #define DP_LINK_CONFIGURATION_SIZE 9
diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/evergreen.c
index 14dce9f..512a19f 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -24,10 +24,10 @@
 #include <linux/firmware.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
-#include "drmP.h"
+#include <drm/drmP.h>
 #include "radeon.h"
 #include "radeon_asic.h"
-#include "radeon_drm.h"
+#include <drm/radeon_drm.h>
 #include "evergreend.h"
 #include "atom.h"
 #include "avivod.h"
diff --git a/drivers/gpu/drm/radeon/evergreen_blit_kms.c b/drivers/gpu/drm/radeon/evergreen_blit_kms.c
index 2eb2518..8d326a6 100644
--- a/drivers/gpu/drm/radeon/evergreen_blit_kms.c
+++ b/drivers/gpu/drm/radeon/evergreen_blit_kms.c
@@ -24,9 +24,9 @@
  *     Alex Deucher <alexander.deucher@amd.com>
  */
 
-#include "drmP.h"
-#include "drm.h"
-#include "radeon_drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/radeon_drm.h>
 #include "radeon.h"
 
 #include "evergreend.h"
diff --git a/drivers/gpu/drm/radeon/evergreen_cs.c b/drivers/gpu/drm/radeon/evergreen_cs.c
index 189e865..b20e96a 100644
--- a/drivers/gpu/drm/radeon/evergreen_cs.c
+++ b/drivers/gpu/drm/radeon/evergreen_cs.c
@@ -25,7 +25,7 @@
  *          Alex Deucher
  *          Jerome Glisse
  */
-#include "drmP.h"
+#include <drm/drmP.h>
 #include "radeon.h"
 #include "evergreend.h"
 #include "evergreen_reg_safe.h"
diff --git a/drivers/gpu/drm/radeon/ni.c b/drivers/gpu/drm/radeon/ni.c
index 44c4750..83121d5 100644
--- a/drivers/gpu/drm/radeon/ni.c
+++ b/drivers/gpu/drm/radeon/ni.c
@@ -24,10 +24,10 @@
 #include <linux/firmware.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
-#include "drmP.h"
+#include <drm/drmP.h>
 #include "radeon.h"
 #include "radeon_asic.h"
-#include "radeon_drm.h"
+#include <drm/radeon_drm.h>
 #include "nid.h"
 #include "atom.h"
 #include "ni_reg.h"
diff --git a/drivers/gpu/drm/radeon/r100.c b/drivers/gpu/drm/radeon/r100.c
index f2204cb..6abfd2f 100644
--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -27,9 +27,9 @@
  */
 #include <linux/seq_file.h>
 #include <linux/slab.h>
-#include "drmP.h"
-#include "drm.h"
-#include "radeon_drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/radeon_drm.h>
 #include "radeon_reg.h"
 #include "radeon.h"
 #include "radeon_asic.h"
diff --git a/drivers/gpu/drm/radeon/r200.c b/drivers/gpu/drm/radeon/r200.c
index f240583..4699472 100644
--- a/drivers/gpu/drm/radeon/r200.c
+++ b/drivers/gpu/drm/radeon/r200.c
@@ -25,9 +25,9 @@
  *          Alex Deucher
  *          Jerome Glisse
  */
-#include "drmP.h"
-#include "drm.h"
-#include "radeon_drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/radeon_drm.h>
 #include "radeon_reg.h"
 #include "radeon.h"
 #include "radeon_asic.h"
diff --git a/drivers/gpu/drm/radeon/r300.c b/drivers/gpu/drm/radeon/r300.c
index 55a7f19..642e1a1 100644
--- a/drivers/gpu/drm/radeon/r300.c
+++ b/drivers/gpu/drm/radeon/r300.c
@@ -33,7 +33,7 @@
 #include "radeon_reg.h"
 #include "radeon.h"
 #include "radeon_asic.h"
-#include "radeon_drm.h"
+#include <drm/radeon_drm.h>
 #include "r100_track.h"
 #include "r300d.h"
 #include "rv350d.h"
diff --git a/drivers/gpu/drm/radeon/r300_cmdbuf.c b/drivers/gpu/drm/radeon/r300_cmdbuf.c
index c5c2742..89b8d83 100644
--- a/drivers/gpu/drm/radeon/r300_cmdbuf.c
+++ b/drivers/gpu/drm/radeon/r300_cmdbuf.c
@@ -31,10 +31,10 @@
  *    Nicolai Haehnle <prefect_@gmx.net>
  */
 
-#include "drmP.h"
-#include "drm.h"
-#include "drm_buffer.h"
-#include "radeon_drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/drm_buffer.h>
+#include <drm/radeon_drm.h>
 #include "radeon_drv.h"
 #include "r300_reg.h"
 
diff --git a/drivers/gpu/drm/radeon/r420.c b/drivers/gpu/drm/radeon/r420.c
index 417fab8..d199e89 100644
--- a/drivers/gpu/drm/radeon/r420.c
+++ b/drivers/gpu/drm/radeon/r420.c
@@ -27,7 +27,7 @@
  */
 #include <linux/seq_file.h>
 #include <linux/slab.h>
-#include "drmP.h"
+#include <drm/drmP.h>
 #include "radeon_reg.h"
 #include "radeon.h"
 #include "radeon_asic.h"
diff --git a/drivers/gpu/drm/radeon/r520.c b/drivers/gpu/drm/radeon/r520.c
index 3081d07..3b45e7d 100644
--- a/drivers/gpu/drm/radeon/r520.c
+++ b/drivers/gpu/drm/radeon/r520.c
@@ -25,7 +25,7 @@
  *          Alex Deucher
  *          Jerome Glisse
  */
-#include "drmP.h"
+#include <drm/drmP.h>
 #include "radeon.h"
 #include "radeon_asic.h"
 #include "atom.h"
diff --git a/drivers/gpu/drm/radeon/r600.c b/drivers/gpu/drm/radeon/r600.c
index aa5571b..7c9888a 100644
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -29,8 +29,8 @@
 #include <linux/seq_file.h>
 #include <linux/firmware.h>
 #include <linux/platform_device.h>
-#include "drmP.h"
-#include "radeon_drm.h"
+#include <drm/drmP.h>
+#include <drm/radeon_drm.h>
 #include "radeon.h"
 #include "radeon_asic.h"
 #include "radeon_mode.h"
diff --git a/drivers/gpu/drm/radeon/r600_audio.c b/drivers/gpu/drm/radeon/r600_audio.c
index 846fae5..9d0f715 100644
--- a/drivers/gpu/drm/radeon/r600_audio.c
+++ b/drivers/gpu/drm/radeon/r600_audio.c
@@ -23,7 +23,7 @@
  *
  * Authors: Christian König
  */
-#include "drmP.h"
+#include <drm/drmP.h>
 #include "radeon.h"
 #include "radeon_reg.h"
 #include "radeon_asic.h"
diff --git a/drivers/gpu/drm/radeon/r600_blit.c b/drivers/gpu/drm/radeon/r600_blit.c
index 7f10434..0d927c7 100644
--- a/drivers/gpu/drm/radeon/r600_blit.c
+++ b/drivers/gpu/drm/radeon/r600_blit.c
@@ -23,9 +23,9 @@
  * Authors:
  *     Alex Deucher <alexander.deucher@amd.com>
  */
-#include "drmP.h"
-#include "drm.h"
-#include "radeon_drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/radeon_drm.h>
 #include "radeon_drv.h"
 
 #include "r600_blit_shaders.h"
diff --git a/drivers/gpu/drm/radeon/r600_blit_kms.c b/drivers/gpu/drm/radeon/r600_blit_kms.c
index 9aa74c3..41c6945 100644
--- a/drivers/gpu/drm/radeon/r600_blit_kms.c
+++ b/drivers/gpu/drm/radeon/r600_blit_kms.c
@@ -23,9 +23,9 @@
  *
  */
 
-#include "drmP.h"
-#include "drm.h"
-#include "radeon_drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/radeon_drm.h>
 #include "radeon.h"
 
 #include "r600d.h"
diff --git a/drivers/gpu/drm/radeon/r600_cp.c b/drivers/gpu/drm/radeon/r600_cp.c
index 45fd592..27f7ec4 100644
--- a/drivers/gpu/drm/radeon/r600_cp.c
+++ b/drivers/gpu/drm/radeon/r600_cp.c
@@ -26,9 +26,9 @@
  *     Alex Deucher <alexander.deucher@amd.com>
  */
 
-#include "drmP.h"
-#include "drm.h"
-#include "radeon_drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/radeon_drm.h>
 #include "radeon_drv.h"
 
 #define PFP_UCODE_SIZE 576
diff --git a/drivers/gpu/drm/radeon/r600_cs.c b/drivers/gpu/drm/radeon/r600_cs.c
index db8ef19..8d78ae9 100644
--- a/drivers/gpu/drm/radeon/r600_cs.c
+++ b/drivers/gpu/drm/radeon/r600_cs.c
@@ -26,7 +26,7 @@
  *          Jerome Glisse
  */
 #include <linux/kernel.h>
-#include "drmP.h"
+#include <drm/drmP.h>
 #include "radeon.h"
 #include "r600d.h"
 #include "r600_reg_safe.h"
diff --git a/drivers/gpu/drm/radeon/r600_hdmi.c b/drivers/gpu/drm/radeon/r600_hdmi.c
index f5ac7e7..e22e5c7 100644
--- a/drivers/gpu/drm/radeon/r600_hdmi.c
+++ b/drivers/gpu/drm/radeon/r600_hdmi.c
@@ -23,8 +23,8 @@
  *
  * Authors: Christian König
  */
-#include "drmP.h"
-#include "radeon_drm.h"
+#include <drm/drmP.h>
+#include <drm/radeon_drm.h>
 #include "radeon.h"
 #include "radeon_asic.h"
 #include "atom.h"
diff --git a/drivers/gpu/drm/radeon/radeon_acpi.c b/drivers/gpu/drm/radeon/radeon_acpi.c
index 3f6636b..b20bb9a 100644
--- a/drivers/gpu/drm/radeon/radeon_acpi.c
+++ b/drivers/gpu/drm/radeon/radeon_acpi.c
@@ -4,10 +4,10 @@
 #include <acpi/acpi_drivers.h>
 #include <acpi/acpi_bus.h>
 
-#include "drmP.h"
-#include "drm.h"
-#include "drm_sarea.h"
-#include "drm_crtc_helper.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/drm_sarea.h>
+#include <drm/drm_crtc_helper.h>
 #include "radeon.h"
 
 #include <linux/vga_switcheroo.h>
diff --git a/drivers/gpu/drm/radeon/radeon_agp.c b/drivers/gpu/drm/radeon/radeon_agp.c
index bd2f33e..6a96811 100644
--- a/drivers/gpu/drm/radeon/radeon_agp.c
+++ b/drivers/gpu/drm/radeon/radeon_agp.c
@@ -24,10 +24,10 @@
  *    Dave Airlie
  *    Jerome Glisse <glisse@freedesktop.org>
  */
-#include "drmP.h"
-#include "drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
 #include "radeon.h"
-#include "radeon_drm.h"
+#include <drm/radeon_drm.h>
 
 #if __OS_HAS_AGP
 
diff --git a/drivers/gpu/drm/radeon/radeon_atombios.c b/drivers/gpu/drm/radeon/radeon_atombios.c
index bf2b615..02b7221 100644
--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -23,8 +23,8 @@
  * Authors: Dave Airlie
  *          Alex Deucher
  */
-#include "drmP.h"
-#include "radeon_drm.h"
+#include <drm/drmP.h>
+#include <drm/radeon_drm.h>
 #include "radeon.h"
 
 #include "atom.h"
diff --git a/drivers/gpu/drm/radeon/radeon_bios.c b/drivers/gpu/drm/radeon/radeon_bios.c
index 229a20f..3c50ebb 100644
--- a/drivers/gpu/drm/radeon/radeon_bios.c
+++ b/drivers/gpu/drm/radeon/radeon_bios.c
@@ -25,7 +25,7 @@
  *          Alex Deucher
  *          Jerome Glisse
  */
-#include "drmP.h"
+#include <drm/drmP.h>
 #include "radeon_reg.h"
 #include "radeon.h"
 #include "atom.h"
diff --git a/drivers/gpu/drm/radeon/radeon_clocks.c b/drivers/gpu/drm/radeon/radeon_clocks.c
index dcd0863e..3972dc1 100644
--- a/drivers/gpu/drm/radeon/radeon_clocks.c
+++ b/drivers/gpu/drm/radeon/radeon_clocks.c
@@ -25,8 +25,8 @@
  *          Alex Deucher
  *          Jerome Glisse
  */
-#include "drmP.h"
-#include "radeon_drm.h"
+#include <drm/drmP.h>
+#include <drm/radeon_drm.h>
 #include "radeon_reg.h"
 #include "radeon.h"
 #include "atom.h"
diff --git a/drivers/gpu/drm/radeon/radeon_combios.c b/drivers/gpu/drm/radeon/radeon_combios.c
index a74217c..a70a3a7 100644
--- a/drivers/gpu/drm/radeon/radeon_combios.c
+++ b/drivers/gpu/drm/radeon/radeon_combios.c
@@ -24,8 +24,8 @@
  * Authors: Dave Airlie
  *          Alex Deucher
  */
-#include "drmP.h"
-#include "radeon_drm.h"
+#include <drm/drmP.h>
+#include <drm/radeon_drm.h>
 #include "radeon.h"
 #include "atom.h"
 
diff --git a/drivers/gpu/drm/radeon/radeon_connectors.c b/drivers/gpu/drm/radeon/radeon_connectors.c
index 9792d4f..3ac2861 100644
--- a/drivers/gpu/drm/radeon/radeon_connectors.c
+++ b/drivers/gpu/drm/radeon/radeon_connectors.c
@@ -23,11 +23,11 @@
  * Authors: Dave Airlie
  *          Alex Deucher
  */
-#include "drmP.h"
-#include "drm_edid.h"
-#include "drm_crtc_helper.h"
-#include "drm_fb_helper.h"
-#include "radeon_drm.h"
+#include <drm/drmP.h>
+#include <drm/drm_edid.h>
+#include <drm/drm_crtc_helper.h>
+#include <drm/drm_fb_helper.h>
+#include <drm/radeon_drm.h>
 #include "radeon.h"
 #include "atom.h"
 
diff --git a/drivers/gpu/drm/radeon/radeon_cp.c b/drivers/gpu/drm/radeon/radeon_cp.c
index 045ec59..d01a7bc 100644
--- a/drivers/gpu/drm/radeon/radeon_cp.c
+++ b/drivers/gpu/drm/radeon/radeon_cp.c
@@ -29,10 +29,10 @@
  *    Gareth Hughes <gareth@valinux.com>
  */
 
-#include "drmP.h"
-#include "drm.h"
-#include "drm_sarea.h"
-#include "radeon_drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/drm_sarea.h>
+#include <drm/radeon_drm.h>
 #include "radeon_drv.h"
 #include "r300_reg.h"
 
diff --git a/drivers/gpu/drm/radeon/radeon_cs.c b/drivers/gpu/drm/radeon/radeon_cs.c
index fae00c0..865733f 100644
--- a/drivers/gpu/drm/radeon/radeon_cs.c
+++ b/drivers/gpu/drm/radeon/radeon_cs.c
@@ -24,8 +24,8 @@
  * Authors:
  *    Jerome Glisse <glisse@freedesktop.org>
  */
-#include "drmP.h"
-#include "radeon_drm.h"
+#include <drm/drmP.h>
+#include <drm/radeon_drm.h>
 #include "radeon_reg.h"
 #include "radeon.h"
 
diff --git a/drivers/gpu/drm/radeon/radeon_cursor.c b/drivers/gpu/drm/radeon/radeon_cursor.c
index 3189a7e..8bd58ce 100644
--- a/drivers/gpu/drm/radeon/radeon_cursor.c
+++ b/drivers/gpu/drm/radeon/radeon_cursor.c
@@ -23,8 +23,8 @@
  * Authors: Dave Airlie
  *          Alex Deucher
  */
-#include "drmP.h"
-#include "radeon_drm.h"
+#include <drm/drmP.h>
+#include <drm/radeon_drm.h>
 #include "radeon.h"
 
 #define CURSOR_WIDTH 64
diff --git a/drivers/gpu/drm/radeon/radeon_display.c b/drivers/gpu/drm/radeon/radeon_display.c
index 28f4655..018e138 100644
--- a/drivers/gpu/drm/radeon/radeon_display.c
+++ b/drivers/gpu/drm/radeon/radeon_display.c
@@ -23,15 +23,15 @@
  * Authors: Dave Airlie
  *          Alex Deucher
  */
-#include "drmP.h"
-#include "radeon_drm.h"
+#include <drm/drmP.h>
+#include <drm/radeon_drm.h>
 #include "radeon.h"
 
 #include "atom.h"
 #include <asm/div64.h>
 
-#include "drm_crtc_helper.h"
-#include "drm_edid.h"
+#include <drm/drm_crtc_helper.h>
+#include <drm/drm_edid.h>
 
 static int radeon_ddc_dump(struct drm_connector *connector);
 
diff --git a/drivers/gpu/drm/radeon/radeon_drv.c b/drivers/gpu/drm/radeon/radeon_drv.c
index 85f033f..a4ea8d2 100644
--- a/drivers/gpu/drm/radeon/radeon_drv.c
+++ b/drivers/gpu/drm/radeon/radeon_drv.c
@@ -29,12 +29,12 @@
  * OTHER DEALINGS IN THE SOFTWARE.
  */
 
-#include "drmP.h"
-#include "drm.h"
-#include "radeon_drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/radeon_drm.h>
 #include "radeon_drv.h"
 
-#include "drm_pciids.h"
+#include <drm/drm_pciids.h>
 #include <linux/console.h>
 
 
diff --git a/drivers/gpu/drm/radeon/radeon_encoders.c b/drivers/gpu/drm/radeon/radeon_encoders.c
index b293487..f0c979d 100644
--- a/drivers/gpu/drm/radeon/radeon_encoders.c
+++ b/drivers/gpu/drm/radeon/radeon_encoders.c
@@ -23,9 +23,9 @@
  * Authors: Dave Airlie
  *          Alex Deucher
  */
-#include "drmP.h"
-#include "drm_crtc_helper.h"
-#include "radeon_drm.h"
+#include <drm/drmP.h>
+#include <drm/drm_crtc_helper.h>
+#include <drm/radeon_drm.h>
 #include "radeon.h"
 #include "atom.h"
 
diff --git a/drivers/gpu/drm/radeon/radeon_fb.c b/drivers/gpu/drm/radeon/radeon_fb.c
index 0b7b486..8b643ee 100644
--- a/drivers/gpu/drm/radeon/radeon_fb.c
+++ b/drivers/gpu/drm/radeon/radeon_fb.c
@@ -27,14 +27,14 @@
 #include <linux/slab.h>
 #include <linux/fb.h>
 
-#include "drmP.h"
-#include "drm.h"
-#include "drm_crtc.h"
-#include "drm_crtc_helper.h"
-#include "radeon_drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/drm_crtc.h>
+#include <drm/drm_crtc_helper.h>
+#include <drm/radeon_drm.h>
 #include "radeon.h"
 
-#include "drm_fb_helper.h"
+#include <drm/drm_fb_helper.h>
 
 #include <linux/vga_switcheroo.h>
 
diff --git a/drivers/gpu/drm/radeon/radeon_fence.c b/drivers/gpu/drm/radeon/radeon_fence.c
index 7fd4e3e..9ea8451 100644
--- a/drivers/gpu/drm/radeon/radeon_fence.c
+++ b/drivers/gpu/drm/radeon/radeon_fence.c
@@ -34,8 +34,8 @@
 #include <linux/list.h>
 #include <linux/kref.h>
 #include <linux/slab.h>
-#include "drmP.h"
-#include "drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
 #include "radeon_reg.h"
 #include "radeon.h"
 #include "radeon_trace.h"
diff --git a/drivers/gpu/drm/radeon/radeon_gart.c b/drivers/gpu/drm/radeon/radeon_gart.c
index a533f52..edab0cb 100644
--- a/drivers/gpu/drm/radeon/radeon_gart.c
+++ b/drivers/gpu/drm/radeon/radeon_gart.c
@@ -25,8 +25,8 @@
  *          Alex Deucher
  *          Jerome Glisse
  */
-#include "drmP.h"
-#include "radeon_drm.h"
+#include <drm/drmP.h>
+#include <drm/radeon_drm.h>
 #include "radeon.h"
 #include "radeon_reg.h"
 
diff --git a/drivers/gpu/drm/radeon/radeon_gem.c b/drivers/gpu/drm/radeon/radeon_gem.c
index aa1ca2d..cb755c9 100644
--- a/drivers/gpu/drm/radeon/radeon_gem.c
+++ b/drivers/gpu/drm/radeon/radeon_gem.c
@@ -25,9 +25,9 @@
  *          Alex Deucher
  *          Jerome Glisse
  */
-#include "drmP.h"
-#include "drm.h"
-#include "radeon_drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/radeon_drm.h>
 #include "radeon.h"
 
 int radeon_gem_object_init(struct drm_gem_object *obj)
diff --git a/drivers/gpu/drm/radeon/radeon_i2c.c b/drivers/gpu/drm/radeon/radeon_i2c.c
index 781196d..1e9c1a7 100644
--- a/drivers/gpu/drm/radeon/radeon_i2c.c
+++ b/drivers/gpu/drm/radeon/radeon_i2c.c
@@ -23,8 +23,8 @@
  * Authors: Dave Airlie
  *          Alex Deucher
  */
-#include "drmP.h"
-#include "radeon_drm.h"
+#include <drm/drmP.h>
+#include <drm/radeon_drm.h>
 #include "radeon.h"
 #include "atom.h"
 
diff --git a/drivers/gpu/drm/radeon/radeon_ioc32.c b/drivers/gpu/drm/radeon/radeon_ioc32.c
index 48b7cea..b1f0917 100644
--- a/drivers/gpu/drm/radeon/radeon_ioc32.c
+++ b/drivers/gpu/drm/radeon/radeon_ioc32.c
@@ -29,9 +29,9 @@
  */
 #include <linux/compat.h>
 
-#include "drmP.h"
-#include "drm.h"
-#include "radeon_drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/radeon_drm.h>
 #include "radeon_drv.h"
 
 typedef struct drm_radeon_init32 {
diff --git a/drivers/gpu/drm/radeon/radeon_irq.c b/drivers/gpu/drm/radeon/radeon_irq.c
index 465746b..07cafc2 100644
--- a/drivers/gpu/drm/radeon/radeon_irq.c
+++ b/drivers/gpu/drm/radeon/radeon_irq.c
@@ -30,9 +30,9 @@
  *    Michel D�zer <michel@daenzer.net>
  */
 
-#include "drmP.h"
-#include "drm.h"
-#include "radeon_drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/radeon_drm.h>
 #include "radeon_drv.h"
 
 void radeon_irq_set_state(struct drm_device *dev, u32 mask, int state)
diff --git a/drivers/gpu/drm/radeon/radeon_irq_kms.c b/drivers/gpu/drm/radeon/radeon_irq_kms.c
index 9ec830c..ef4d1f1 100644
--- a/drivers/gpu/drm/radeon/radeon_irq_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_irq_kms.c
@@ -25,9 +25,9 @@
  *          Alex Deucher
  *          Jerome Glisse
  */
-#include "drmP.h"
-#include "drm_crtc_helper.h"
-#include "radeon_drm.h"
+#include <drm/drmP.h>
+#include <drm/drm_crtc_helper.h>
+#include <drm/radeon_drm.h>
 #include "radeon_reg.h"
 #include "radeon.h"
 #include "atom.h"
diff --git a/drivers/gpu/drm/radeon/radeon_kms.c b/drivers/gpu/drm/radeon/radeon_kms.c
index be2c122..84e0a15 100644
--- a/drivers/gpu/drm/radeon/radeon_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_kms.c
@@ -25,10 +25,10 @@
  *          Alex Deucher
  *          Jerome Glisse
  */
-#include "drmP.h"
-#include "drm_sarea.h"
+#include <drm/drmP.h>
+#include <drm/drm_sarea.h>
 #include "radeon.h"
-#include "radeon_drm.h"
+#include <drm/radeon_drm.h>
 
 #include <linux/vga_switcheroo.h>
 #include <linux/slab.h>
diff --git a/drivers/gpu/drm/radeon/radeon_legacy_encoders.c b/drivers/gpu/drm/radeon/radeon_legacy_encoders.c
index 2f46e0c..5db15a0 100644
--- a/drivers/gpu/drm/radeon/radeon_legacy_encoders.c
+++ b/drivers/gpu/drm/radeon/radeon_legacy_encoders.c
@@ -23,9 +23,9 @@
  * Authors: Dave Airlie
  *          Alex Deucher
  */
-#include "drmP.h"
-#include "drm_crtc_helper.h"
-#include "radeon_drm.h"
+#include <drm/drmP.h>
+#include <drm/drm_crtc_helper.h>
+#include <drm/radeon_drm.h>
 #include "radeon.h"
 #include "atom.h"
 #include <linux/backlight.h>
diff --git a/drivers/gpu/drm/radeon/radeon_legacy_tv.c b/drivers/gpu/drm/radeon/radeon_legacy_tv.c
index c7b6cb4..3b05927 100644
--- a/drivers/gpu/drm/radeon/radeon_legacy_tv.c
+++ b/drivers/gpu/drm/radeon/radeon_legacy_tv.c
@@ -1,5 +1,5 @@
-#include "drmP.h"
-#include "drm_crtc_helper.h"
+#include <drm/drmP.h>
+#include <drm/drm_crtc_helper.h>
 #include "radeon.h"
 
 /*
diff --git a/drivers/gpu/drm/radeon/radeon_mem.c b/drivers/gpu/drm/radeon/radeon_mem.c
index 988548e..91168a0 100644
--- a/drivers/gpu/drm/radeon/radeon_mem.c
+++ b/drivers/gpu/drm/radeon/radeon_mem.c
@@ -29,9 +29,9 @@
  *    Keith Whitwell <keith@tungstengraphics.com>
  */
 
-#include "drmP.h"
-#include "drm.h"
-#include "radeon_drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/radeon_drm.h>
 #include "radeon_drv.h"
 
 /* Very simple allocator for GART memory, working on a static range
diff --git a/drivers/gpu/drm/radeon/radeon_object.c b/drivers/gpu/drm/radeon/radeon_object.c
index 976c3b1..f33ed78 100644
--- a/drivers/gpu/drm/radeon/radeon_object.c
+++ b/drivers/gpu/drm/radeon/radeon_object.c
@@ -32,7 +32,7 @@
 #include <linux/list.h>
 #include <linux/slab.h>
 #include <drm/drmP.h>
-#include "radeon_drm.h"
+#include <drm/radeon_drm.h>
 #include "radeon.h"
 #include "radeon_trace.h"
 
diff --git a/drivers/gpu/drm/radeon/radeon_pm.c b/drivers/gpu/drm/radeon/radeon_pm.c
index 6fabe89..c5751f3 100644
--- a/drivers/gpu/drm/radeon/radeon_pm.c
+++ b/drivers/gpu/drm/radeon/radeon_pm.c
@@ -20,7 +20,7 @@
  * Authors: Rafał Miłecki <zajec5@gmail.com>
  *          Alex Deucher <alexdeucher@gmail.com>
  */
-#include "drmP.h"
+#include <drm/drmP.h>
 #include "radeon.h"
 #include "avivod.h"
 #include "atom.h"
diff --git a/drivers/gpu/drm/radeon/radeon_ring.c b/drivers/gpu/drm/radeon/radeon_ring.c
index 08c0233..600767d 100644
--- a/drivers/gpu/drm/radeon/radeon_ring.c
+++ b/drivers/gpu/drm/radeon/radeon_ring.c
@@ -27,8 +27,8 @@
  */
 #include <linux/seq_file.h>
 #include <linux/slab.h>
-#include "drmP.h"
-#include "radeon_drm.h"
+#include <drm/drmP.h>
+#include <drm/radeon_drm.h>
 #include "radeon_reg.h"
 #include "radeon.h"
 #include "atom.h"
diff --git a/drivers/gpu/drm/radeon/radeon_state.c b/drivers/gpu/drm/radeon/radeon_state.c
index 92e7ea7..51955aa 100644
--- a/drivers/gpu/drm/radeon/radeon_state.c
+++ b/drivers/gpu/drm/radeon/radeon_state.c
@@ -27,11 +27,11 @@
  *    Kevin E. Martin <martin@valinux.com>
  */
 
-#include "drmP.h"
-#include "drm.h"
-#include "drm_buffer.h"
-#include "drm_sarea.h"
-#include "radeon_drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/drm_buffer.h>
+#include <drm/drm_sarea.h>
+#include <drm/radeon_drm.h>
 #include "radeon_drv.h"
 
 /* ================================================================
diff --git a/drivers/gpu/drm/radeon/radeon_trace_points.c b/drivers/gpu/drm/radeon/radeon_trace_points.c
index 8175993..e51d357 100644
--- a/drivers/gpu/drm/radeon/radeon_trace_points.c
+++ b/drivers/gpu/drm/radeon/radeon_trace_points.c
@@ -2,7 +2,7 @@
  * Author : Dave Airlie <airlied@redhat.com>
  */
 #include <drm/drmP.h>
-#include "radeon_drm.h"
+#include <drm/radeon_drm.h>
 #include "radeon.h"
 
 #define CREATE_TRACE_POINTS
diff --git a/drivers/gpu/drm/radeon/rs600.c b/drivers/gpu/drm/radeon/rs600.c
index 4b5d0e6..a85cc23 100644
--- a/drivers/gpu/drm/radeon/rs600.c
+++ b/drivers/gpu/drm/radeon/rs600.c
@@ -35,7 +35,7 @@
  * close to the one of the R600 family (R600 likely being an evolution
  * of the RS600 GART block).
  */
-#include "drmP.h"
+#include <drm/drmP.h>
 #include "radeon.h"
 #include "radeon_asic.h"
 #include "atom.h"
diff --git a/drivers/gpu/drm/radeon/rs690.c b/drivers/gpu/drm/radeon/rs690.c
index a9049ed..1e6c745 100644
--- a/drivers/gpu/drm/radeon/rs690.c
+++ b/drivers/gpu/drm/radeon/rs690.c
@@ -25,7 +25,7 @@
  *          Alex Deucher
  *          Jerome Glisse
  */
-#include "drmP.h"
+#include <drm/drmP.h>
 #include "radeon.h"
 #include "radeon_asic.h"
 #include "atom.h"
diff --git a/drivers/gpu/drm/radeon/rv515.c b/drivers/gpu/drm/radeon/rv515.c
index 6613ee9..00b9aac 100644
--- a/drivers/gpu/drm/radeon/rv515.c
+++ b/drivers/gpu/drm/radeon/rv515.c
@@ -27,7 +27,7 @@
  */
 #include <linux/seq_file.h>
 #include <linux/slab.h>
-#include "drmP.h"
+#include <drm/drmP.h>
 #include "rv515d.h"
 #include "radeon.h"
 #include "radeon_asic.h"
diff --git a/drivers/gpu/drm/radeon/rv770.c b/drivers/gpu/drm/radeon/rv770.c
index 4720d00..eee7c80 100644
--- a/drivers/gpu/drm/radeon/rv770.c
+++ b/drivers/gpu/drm/radeon/rv770.c
@@ -28,10 +28,10 @@
 #include <linux/firmware.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
-#include "drmP.h"
+#include <drm/drmP.h>
 #include "radeon.h"
 #include "radeon_asic.h"
-#include "radeon_drm.h"
+#include <drm/radeon_drm.h>
 #include "rv770d.h"
 #include "atom.h"
 #include "avivod.h"
diff --git a/drivers/gpu/drm/savage/savage_bci.c b/drivers/gpu/drm/savage/savage_bci.c
index cb1ee4e..ca2200b 100644
--- a/drivers/gpu/drm/savage/savage_bci.c
+++ b/drivers/gpu/drm/savage/savage_bci.c
@@ -22,8 +22,8 @@
  * CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
  * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
  */
-#include "drmP.h"
-#include "savage_drm.h"
+#include <drm/drmP.h>
+#include <drm/savage_drm.h>
 #include "savage_drv.h"
 
 /* Need a long timeout for shadow status updates can take a while
diff --git a/drivers/gpu/drm/savage/savage_drv.c b/drivers/gpu/drm/savage/savage_drv.c
index 6464490..cfc2096 100644
--- a/drivers/gpu/drm/savage/savage_drv.c
+++ b/drivers/gpu/drm/savage/savage_drv.c
@@ -23,11 +23,11 @@
  * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
  */
 
-#include "drmP.h"
-#include "savage_drm.h"
+#include <drm/drmP.h>
+#include <drm/savage_drm.h>
 #include "savage_drv.h"
 
-#include "drm_pciids.h"
+#include <drm/drm_pciids.h>
 
 static struct pci_device_id pciidlist[] = {
 	savage_PCI_IDS
diff --git a/drivers/gpu/drm/savage/savage_state.c b/drivers/gpu/drm/savage/savage_state.c
index 8a3e315..3a6552a 100644
--- a/drivers/gpu/drm/savage/savage_state.c
+++ b/drivers/gpu/drm/savage/savage_state.c
@@ -22,8 +22,8 @@
  * CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
  * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
  */
-#include "drmP.h"
-#include "savage_drm.h"
+#include <drm/drmP.h>
+#include <drm/savage_drm.h>
 #include "savage_drv.h"
 
 void savage_emit_clip_rect_s3d(drm_savage_private_t * dev_priv,
diff --git a/drivers/gpu/drm/sis/sis_drv.c b/drivers/gpu/drm/sis/sis_drv.c
index 46d5be6..13390e9 100644
--- a/drivers/gpu/drm/sis/sis_drv.c
+++ b/drivers/gpu/drm/sis/sis_drv.c
@@ -25,11 +25,11 @@
  *
  */
 
-#include "drmP.h"
-#include "sis_drm.h"
+#include <drm/drmP.h>
+#include <drm/sis_drm.h>
 #include "sis_drv.h"
 
-#include "drm_pciids.h"
+#include <drm/drm_pciids.h>
 
 static struct pci_device_id pciidlist[] = {
 	sisdrv_PCI_IDS
diff --git a/drivers/gpu/drm/sis/sis_drv.h b/drivers/gpu/drm/sis/sis_drv.h
index 194303c..0b3ab54 100644
--- a/drivers/gpu/drm/sis/sis_drv.h
+++ b/drivers/gpu/drm/sis/sis_drv.h
@@ -44,7 +44,7 @@ enum sis_family {
 	SIS_CHIP_315 = 1,
 };
 
-#include "drm_sman.h"
+#include <drm/drm_sman.h>
 
 
 #define SIS_BASE (dev_priv->mmio)
diff --git a/drivers/gpu/drm/sis/sis_mm.c b/drivers/gpu/drm/sis/sis_mm.c
index 7fe2b63..304e0a7 100644
--- a/drivers/gpu/drm/sis/sis_mm.c
+++ b/drivers/gpu/drm/sis/sis_mm.c
@@ -31,8 +31,8 @@
  *    Thomas Hellström <thomas-at-tungstengraphics-dot-com>
  */
 
-#include "drmP.h"
-#include "sis_drm.h"
+#include <drm/drmP.h>
+#include <drm/sis_drm.h>
 #include "sis_drv.h"
 
 #include <video/sisfb.h>
diff --git a/drivers/gpu/drm/tdfx/tdfx_drv.c b/drivers/gpu/drm/tdfx/tdfx_drv.c
index 8bf9881..44034c2 100644
--- a/drivers/gpu/drm/tdfx/tdfx_drv.c
+++ b/drivers/gpu/drm/tdfx/tdfx_drv.c
@@ -30,10 +30,10 @@
  *    Gareth Hughes <gareth@valinux.com>
  */
 
-#include "drmP.h"
+#include <drm/drmP.h>
 #include "tdfx_drv.h"
 
-#include "drm_pciids.h"
+#include <drm/drm_pciids.h>
 
 static struct pci_device_id pciidlist[] = {
 	tdfx_PCI_IDS
diff --git a/drivers/gpu/drm/ttm/ttm_agp_backend.c b/drivers/gpu/drm/ttm/ttm_agp_backend.c
index 1c4a72f..8cf9653 100644
--- a/drivers/gpu/drm/ttm/ttm_agp_backend.c
+++ b/drivers/gpu/drm/ttm/ttm_agp_backend.c
@@ -29,10 +29,10 @@
  *          Keith Packard.
  */
 
-#include "ttm/ttm_module.h"
-#include "ttm/ttm_bo_driver.h"
+#include <drm/ttm/ttm_module.h>
+#include <drm/ttm/ttm_bo_driver.h>
 #ifdef TTM_HAS_AGP
-#include "ttm/ttm_placement.h"
+#include <drm/ttm/ttm_placement.h>
 #include <linux/agp_backend.h>
 #include <linux/module.h>
 #include <linux/slab.h>
diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
index 56619f6..c0dad9e 100644
--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -28,9 +28,9 @@
  * Authors: Thomas Hellstrom <thellstrom-at-vmware-dot-com>
  */
 
-#include "ttm/ttm_module.h"
-#include "ttm/ttm_bo_driver.h"
-#include "ttm/ttm_placement.h"
+#include <drm/ttm/ttm_module.h>
+#include <drm/ttm/ttm_bo_driver.h>
+#include <drm/ttm/ttm_placement.h>
 #include <linux/jiffies.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
diff --git a/drivers/gpu/drm/ttm/ttm_bo_manager.c b/drivers/gpu/drm/ttm/ttm_bo_manager.c
index 038e947..9212494 100644
--- a/drivers/gpu/drm/ttm/ttm_bo_manager.c
+++ b/drivers/gpu/drm/ttm/ttm_bo_manager.c
@@ -28,10 +28,10 @@
  * Authors: Thomas Hellstrom <thellstrom-at-vmware-dot-com>
  */
 
-#include "ttm/ttm_module.h"
-#include "ttm/ttm_bo_driver.h"
-#include "ttm/ttm_placement.h"
-#include "drm_mm.h"
+#include <drm/ttm/ttm_module.h>
+#include <drm/ttm/ttm_bo_driver.h>
+#include <drm/ttm/ttm_placement.h>
+#include <drm/drm_mm.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/module.h>
diff --git a/drivers/gpu/drm/ttm/ttm_bo_util.c b/drivers/gpu/drm/ttm/ttm_bo_util.c
index 77dbf40..446f9d3 100644
--- a/drivers/gpu/drm/ttm/ttm_bo_util.c
+++ b/drivers/gpu/drm/ttm/ttm_bo_util.c
@@ -28,8 +28,8 @@
  * Authors: Thomas Hellstrom <thellstrom-at-vmware-dot-com>
  */
 
-#include "ttm/ttm_bo_driver.h"
-#include "ttm/ttm_placement.h"
+#include <drm/ttm/ttm_bo_driver.h>
+#include <drm/ttm/ttm_placement.h>
 #include <linux/io.h>
 #include <linux/highmem.h>
 #include <linux/wait.h>
diff --git a/drivers/gpu/drm/ttm/ttm_execbuf_util.c b/drivers/gpu/drm/ttm/ttm_execbuf_util.c
index 3832fe1..1937069 100644
--- a/drivers/gpu/drm/ttm/ttm_execbuf_util.c
+++ b/drivers/gpu/drm/ttm/ttm_execbuf_util.c
@@ -25,9 +25,9 @@
  *
  **************************************************************************/
 
-#include "ttm/ttm_execbuf_util.h"
-#include "ttm/ttm_bo_driver.h"
-#include "ttm/ttm_placement.h"
+#include <drm/ttm/ttm_execbuf_util.h>
+#include <drm/ttm/ttm_bo_driver.h>
+#include <drm/ttm/ttm_placement.h>
 #include <linux/wait.h>
 #include <linux/sched.h>
 #include <linux/module.h>
diff --git a/drivers/gpu/drm/ttm/ttm_lock.c b/drivers/gpu/drm/ttm/ttm_lock.c
index 075daf4..3daa9a3 100644
--- a/drivers/gpu/drm/ttm/ttm_lock.c
+++ b/drivers/gpu/drm/ttm/ttm_lock.c
@@ -28,8 +28,8 @@
  * Authors: Thomas Hellstrom <thellstrom-at-vmware-dot-com>
  */
 
-#include "ttm/ttm_lock.h"
-#include "ttm/ttm_module.h"
+#include <drm/ttm/ttm_lock.h>
+#include <drm/ttm/ttm_module.h>
 #include <linux/atomic.h>
 #include <linux/errno.h>
 #include <linux/wait.h>
diff --git a/drivers/gpu/drm/ttm/ttm_memory.c b/drivers/gpu/drm/ttm/ttm_memory.c
index e70ddd8..93299d9 100644
--- a/drivers/gpu/drm/ttm/ttm_memory.c
+++ b/drivers/gpu/drm/ttm/ttm_memory.c
@@ -25,9 +25,9 @@
  *
  **************************************************************************/
 
-#include "ttm/ttm_memory.h"
-#include "ttm/ttm_module.h"
-#include "ttm/ttm_page_alloc.h"
+#include <drm/ttm/ttm_memory.h>
+#include <drm/ttm/ttm_module.h>
+#include <drm/ttm/ttm_page_alloc.h>
 #include <linux/spinlock.h>
 #include <linux/sched.h>
 #include <linux/wait.h>
diff --git a/drivers/gpu/drm/ttm/ttm_module.c b/drivers/gpu/drm/ttm/ttm_module.c
index 902d7cf..d7f92fe 100644
--- a/drivers/gpu/drm/ttm/ttm_module.c
+++ b/drivers/gpu/drm/ttm/ttm_module.c
@@ -31,8 +31,8 @@
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/sched.h>
-#include "ttm/ttm_module.h"
-#include "drm_sysfs.h"
+#include <drm/ttm/ttm_module.h>
+#include <drm/drm_sysfs.h>
 
 static DECLARE_WAIT_QUEUE_HEAD(exit_q);
 atomic_t device_released;
diff --git a/drivers/gpu/drm/ttm/ttm_object.c b/drivers/gpu/drm/ttm/ttm_object.c
index 93577f2..bb04087 100644
--- a/drivers/gpu/drm/ttm/ttm_object.c
+++ b/drivers/gpu/drm/ttm/ttm_object.c
@@ -49,8 +49,8 @@
  * for fast lookup of ref objects given a base object.
  */
 
-#include "ttm/ttm_object.h"
-#include "ttm/ttm_module.h"
+#include <drm/ttm/ttm_object.h>
+#include <drm/ttm/ttm_module.h>
 #include <linux/list.h>
 #include <linux/spinlock.h>
 #include <linux/slab.h>
diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc.c b/drivers/gpu/drm/ttm/ttm_page_alloc.c
index 727e93d..74c19e3 100644
--- a/drivers/gpu/drm/ttm/ttm_page_alloc.c
+++ b/drivers/gpu/drm/ttm/ttm_page_alloc.c
@@ -42,8 +42,8 @@
 
 #include <linux/atomic.h>
 
-#include "ttm/ttm_bo_driver.h"
-#include "ttm/ttm_page_alloc.h"
+#include <drm/ttm/ttm_bo_driver.h>
+#include <drm/ttm/ttm_page_alloc.h>
 
 #ifdef TTM_HAS_AGP
 #include <asm/agp.h>
diff --git a/drivers/gpu/drm/ttm/ttm_tt.c b/drivers/gpu/drm/ttm/ttm_tt.c
index 58c271e..e271a7e 100644
--- a/drivers/gpu/drm/ttm/ttm_tt.c
+++ b/drivers/gpu/drm/ttm/ttm_tt.c
@@ -35,12 +35,12 @@
 #include <linux/file.h>
 #include <linux/swap.h>
 #include <linux/slab.h>
-#include "drm_cache.h"
-#include "drm_mem_util.h"
-#include "ttm/ttm_module.h"
-#include "ttm/ttm_bo_driver.h"
-#include "ttm/ttm_placement.h"
-#include "ttm/ttm_page_alloc.h"
+#include <drm/drm_cache.h>
+#include <drm/drm_mem_util.h>
+#include <drm/ttm/ttm_module.h>
+#include <drm/ttm/ttm_bo_driver.h>
+#include <drm/ttm/ttm_placement.h>
+#include <drm/ttm/ttm_page_alloc.h>
 
 static int ttm_tt_swapin(struct ttm_tt *ttm);
 
diff --git a/drivers/gpu/drm/via/via_dma.c b/drivers/gpu/drm/via/via_dma.c
index cc0ffa9..869dabe 100644
--- a/drivers/gpu/drm/via/via_dma.c
+++ b/drivers/gpu/drm/via/via_dma.c
@@ -34,9 +34,9 @@
  *    Thomas Hellstrom.
  */
 
-#include "drmP.h"
-#include "drm.h"
-#include "via_drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/via_drm.h>
 #include "via_drv.h"
 #include "via_3d_reg.h"
 
diff --git a/drivers/gpu/drm/via/via_dmablit.c b/drivers/gpu/drm/via/via_dmablit.c
index 3e038a3..8b0f259 100644
--- a/drivers/gpu/drm/via/via_dmablit.c
+++ b/drivers/gpu/drm/via/via_dmablit.c
@@ -34,8 +34,8 @@
  * the same DMA mappings?
  */
 
-#include "drmP.h"
-#include "via_drm.h"
+#include <drm/drmP.h>
+#include <drm/via_drm.h>
 #include "via_drv.h"
 #include "via_dmablit.h"
 
diff --git a/drivers/gpu/drm/via/via_drv.c b/drivers/gpu/drm/via/via_drv.c
index 920a552..acf9c78 100644
--- a/drivers/gpu/drm/via/via_drv.c
+++ b/drivers/gpu/drm/via/via_drv.c
@@ -22,11 +22,11 @@
  * DEALINGS IN THE SOFTWARE.
  */
 
-#include "drmP.h"
-#include "via_drm.h"
+#include <drm/drmP.h>
+#include <drm/via_drm.h>
 #include "via_drv.h"
 
-#include "drm_pciids.h"
+#include <drm/drm_pciids.h>
 
 static struct pci_device_id pciidlist[] = {
 	viadrv_PCI_IDS
diff --git a/drivers/gpu/drm/via/via_drv.h b/drivers/gpu/drm/via/via_drv.h
index 9cf87d9..fcb677e 100644
--- a/drivers/gpu/drm/via/via_drv.h
+++ b/drivers/gpu/drm/via/via_drv.h
@@ -24,7 +24,7 @@
 #ifndef _VIA_DRV_H_
 #define _VIA_DRV_H_
 
-#include "drm_sman.h"
+#include <drm/drm_sman.h>
 #define DRIVER_AUTHOR	"Various"
 
 #define DRIVER_NAME		"via"
diff --git a/drivers/gpu/drm/via/via_irq.c b/drivers/gpu/drm/via/via_irq.c
index d391f48..8da2c6e 100644
--- a/drivers/gpu/drm/via/via_irq.c
+++ b/drivers/gpu/drm/via/via_irq.c
@@ -35,9 +35,9 @@
  * The refresh rate is also calculated for video playback sync purposes.
  */
 
-#include "drmP.h"
-#include "drm.h"
-#include "via_drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/via_drm.h>
 #include "via_drv.h"
 
 #define VIA_REG_INTERRUPT       0x200
diff --git a/drivers/gpu/drm/via/via_map.c b/drivers/gpu/drm/via/via_map.c
index 6cca9a7..6056643 100644
--- a/drivers/gpu/drm/via/via_map.c
+++ b/drivers/gpu/drm/via/via_map.c
@@ -21,8 +21,8 @@
  * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
  * DEALINGS IN THE SOFTWARE.
  */
-#include "drmP.h"
-#include "via_drm.h"
+#include <drm/drmP.h>
+#include <drm/via_drm.h>
 #include "via_drv.h"
 
 static int via_do_init_map(struct drm_device *dev, drm_via_init_t *init)
diff --git a/drivers/gpu/drm/via/via_mm.c b/drivers/gpu/drm/via/via_mm.c
index 6cc2dad..4c352a7 100644
--- a/drivers/gpu/drm/via/via_mm.c
+++ b/drivers/gpu/drm/via/via_mm.c
@@ -25,10 +25,10 @@
  * Authors: Thomas Hellström <thomas-at-tungstengraphics-dot-com>
  */
 
-#include "drmP.h"
-#include "via_drm.h"
+#include <drm/drmP.h>
+#include <drm/via_drm.h>
 #include "via_drv.h"
-#include "drm_sman.h"
+#include <drm/drm_sman.h>
 
 #define VIA_MM_ALIGN_SHIFT 4
 #define VIA_MM_ALIGN_MASK ((1 << VIA_MM_ALIGN_SHIFT) - 1)
diff --git a/drivers/gpu/drm/via/via_verifier.c b/drivers/gpu/drm/via/via_verifier.c
index 48957b8..951244c 100644
--- a/drivers/gpu/drm/via/via_verifier.c
+++ b/drivers/gpu/drm/via/via_verifier.c
@@ -29,9 +29,9 @@
  */
 
 #include "via_3d_reg.h"
-#include "drmP.h"
-#include "drm.h"
-#include "via_drm.h"
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/via_drm.h>
 #include "via_verifier.h"
 #include "via_drv.h"
 
diff --git a/drivers/gpu/drm/via/via_video.c b/drivers/gpu/drm/via/via_video.c
index 675d311..6569efa 100644
--- a/drivers/gpu/drm/via/via_video.c
+++ b/drivers/gpu/drm/via/via_video.c
@@ -25,8 +25,8 @@
  * Video and XvMC related functions.
  */
 
-#include "drmP.h"
-#include "via_drm.h"
+#include <drm/drmP.h>
+#include <drm/via_drm.h>
 #include "via_drv.h"
 
 void via_init_futex(drm_via_private_t *dev_priv)
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_buffer.c b/drivers/gpu/drm/vmwgfx/vmwgfx_buffer.c
index 87e43e0..0ccc022 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_buffer.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_buffer.c
@@ -26,8 +26,8 @@
  **************************************************************************/
 
 #include "vmwgfx_drv.h"
-#include "ttm/ttm_bo_driver.h"
-#include "ttm/ttm_placement.h"
+#include <drm/ttm/ttm_bo_driver.h>
+#include <drm/ttm/ttm_placement.h>
 
 static uint32_t vram_placement_flags = TTM_PL_FLAG_VRAM |
 	TTM_PL_FLAG_CACHED;
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
index 96949b9..89908e9 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
@@ -25,12 +25,12 @@
  *
  **************************************************************************/
 
-#include "drmP.h"
+#include <drm/drmP.h>
 #include "vmwgfx_drv.h"
-#include "ttm/ttm_placement.h"
-#include "ttm/ttm_bo_driver.h"
-#include "ttm/ttm_object.h"
-#include "ttm/ttm_module.h"
+#include <drm/ttm/ttm_placement.h>
+#include <drm/ttm/ttm_bo_driver.h>
+#include <drm/ttm/ttm_object.h>
+#include <drm/ttm/ttm_module.h>
 
 #define VMWGFX_DRIVER_NAME "vmwgfx"
 #define VMWGFX_DRIVER_DESC "Linux drm driver for VMware graphics devices"
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
index 10fc01f..f528316 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
@@ -29,15 +29,15 @@
 #define _VMWGFX_DRV_H_
 
 #include "vmwgfx_reg.h"
-#include "drmP.h"
-#include "vmwgfx_drm.h"
-#include "drm_hashtab.h"
-#include "linux/suspend.h"
-#include "ttm/ttm_bo_driver.h"
-#include "ttm/ttm_object.h"
-#include "ttm/ttm_lock.h"
-#include "ttm/ttm_execbuf_util.h"
-#include "ttm/ttm_module.h"
+#include <drm/drmP.h>
+#include <drm/vmwgfx_drm.h>
+#include <drm/drm_hashtab.h>
+#include <linux/suspend.h>
+#include <drm/ttm/ttm_bo_driver.h>
+#include <drm/ttm/ttm_object.h>
+#include <drm/ttm/ttm_lock.h>
+#include <drm/ttm/ttm_execbuf_util.h>
+#include <drm/ttm/ttm_module.h>
 
 #define VMWGFX_DRIVER_DATE "20100927"
 #define VMWGFX_DRIVER_MAJOR 1
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
index 41b95ed..93a1ebb 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
@@ -27,8 +27,8 @@
 
 #include "vmwgfx_drv.h"
 #include "vmwgfx_reg.h"
-#include "ttm/ttm_bo_api.h"
-#include "ttm/ttm_placement.h"
+#include <drm/ttm/ttm_bo_api.h>
+#include <drm/ttm/ttm_placement.h>
 
 static int vmw_cmd_invalid(struct vmw_private *dev_priv,
 			   struct vmw_sw_context *sw_context,
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_fb.c b/drivers/gpu/drm/vmwgfx/vmwgfx_fb.c
index bfab60c..68707af 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_fb.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_fb.c
@@ -26,10 +26,10 @@
  *
  **************************************************************************/
 
-#include "drmP.h"
+#include <drm/drmP.h>
 #include "vmwgfx_drv.h"
 
-#include "ttm/ttm_placement.h"
+#include <drm/ttm/ttm_placement.h>
 
 #define VMW_DIRTY_DELAY (HZ / 30)
 
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c b/drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c
index 635c0ff..b0e7659 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c
@@ -26,8 +26,8 @@
  **************************************************************************/
 
 #include "vmwgfx_drv.h"
-#include "drmP.h"
-#include "ttm/ttm_placement.h"
+#include <drm/drmP.h>
+#include <drm/ttm/ttm_placement.h>
 
 bool vmw_fifo_have_3d(struct vmw_private *dev_priv)
 {
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_gmr.c b/drivers/gpu/drm/vmwgfx/vmwgfx_gmr.c
index de0c594..7a6391e 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_gmr.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_gmr.c
@@ -26,8 +26,8 @@
  **************************************************************************/
 
 #include "vmwgfx_drv.h"
-#include "drmP.h"
-#include "ttm/ttm_bo_driver.h"
+#include <drm/drmP.h>
+#include <drm/ttm/ttm_bo_driver.h>
 
 /**
  * FIXME: Adjust to the ttm lowmem / highmem storage to minimize
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_gmrid_manager.c b/drivers/gpu/drm/vmwgfx/vmwgfx_gmrid_manager.c
index ac6e0d1..56dc40a 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_gmrid_manager.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_gmrid_manager.c
@@ -29,9 +29,9 @@
  */
 
 #include "vmwgfx_drv.h"
-#include "ttm/ttm_module.h"
-#include "ttm/ttm_bo_driver.h"
-#include "ttm/ttm_placement.h"
+#include <drm/ttm/ttm_module.h>
+#include <drm/ttm/ttm_bo_driver.h>
+#include <drm/ttm/ttm_placement.h>
 #include <linux/idr.h>
 #include <linux/spinlock.h>
 #include <linux/kernel.h>
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_ioctl.c b/drivers/gpu/drm/vmwgfx/vmwgfx_ioctl.c
index 570d577..7dd6213 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_ioctl.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_ioctl.c
@@ -26,7 +26,7 @@
  **************************************************************************/
 
 #include "vmwgfx_drv.h"
-#include "vmwgfx_drm.h"
+#include <drm/vmwgfx_drm.h>
 
 int vmw_getparam_ioctl(struct drm_device *dev, void *data,
 		       struct drm_file *file_priv)
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_irq.c b/drivers/gpu/drm/vmwgfx/vmwgfx_irq.c
index e92298a..cb9a4f6 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_irq.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_irq.c
@@ -25,7 +25,7 @@
  *
  **************************************************************************/
 
-#include "drmP.h"
+#include <drm/drmP.h>
 #include "vmwgfx_drv.h"
 
 #define VMW_FENCE_WRAP (1 << 24)
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.h b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.h
index 8a398a0..0bc37a4 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.h
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.h
@@ -28,7 +28,7 @@
 #ifndef VMWGFX_KMS_H_
 #define VMWGFX_KMS_H_
 
-#include "drmP.h"
+#include <drm/drmP.h>
 #include "vmwgfx_drv.h"
 
 
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c b/drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c
index 07ce02d..921b90c 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c
@@ -26,10 +26,10 @@
  **************************************************************************/
 
 
-#include "drmP.h"
+#include <drm/drmP.h>
 #include "vmwgfx_drv.h"
 
-#include "ttm/ttm_placement.h"
+#include <drm/ttm/ttm_placement.h>
 
 #include "svga_overlay.h"
 #include "svga_escape.h"
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c b/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
index bfe1bcc..a5b7a1e 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
@@ -26,10 +26,10 @@
  **************************************************************************/
 
 #include "vmwgfx_drv.h"
-#include "vmwgfx_drm.h"
-#include "ttm/ttm_object.h"
-#include "ttm/ttm_placement.h"
-#include "drmP.h"
+#include <drm/vmwgfx_drm.h>
+#include <drm/ttm/ttm_object.h>
+#include <drm/ttm/ttm_placement.h>
+#include <drm/drmP.h>
 
 #define VMW_RES_CONTEXT ttm_driver_type0
 #define VMW_RES_SURFACE ttm_driver_type1
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_ttm_glue.c b/drivers/gpu/drm/vmwgfx/vmwgfx_ttm_glue.c
index 1e8eedd..f48721e 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_ttm_glue.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_ttm_glue.c
@@ -25,7 +25,7 @@
  *
  **************************************************************************/
 
-#include "drmP.h"
+#include <drm/drmP.h>
 #include "vmwgfx_drv.h"
 
 int vmw_mmap(struct file *filp, struct vm_area_struct *vma)

