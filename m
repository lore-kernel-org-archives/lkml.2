Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337Ab1CHJXH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 04:23:07 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38960 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844Ab1CHJXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 04:23:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PBGp8x3/SDZTQhYPgSwAmGB/t8K72Aokt/anXLuZzFg8JUVDt3pzN8nos7jBSL+azr
         k2L6L8Sm/UHac1xOb6y1XDzuyvGpWdFFEWRlvKmgHjfUN7CtgegRQgNiSzAkGT+db0e6
         QjkvUkkFxsC5vaOqIsNQ834VqIU+5l2lB+5d0=
Date: Tue, 8 Mar 2011 11:22:54 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, bskeggs@redhat.com
Subject: 2.6.38-rc8: lockdep vs nouveau
Message-ID: <20110308092254.GA4909@p183.telecom.by>
References: <AANLkTimG-1nSZw3P5q7LQbGmQch3ibsMPQ_duhAjhtQH@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimG-1nSZw3P5q7LQbGmQch3ibsMPQ_duhAjhtQH@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Happened at boot.

[drm] Initialized drm 1.1.0 20060810
nouveau 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
nouveau 0000:01:00.0: setting latency timer to 64
[drm] nouveau 0000:01:00.0: Detected an NV50 generation card (0x450100a2)
[drm] nouveau 0000:01:00.0: Attempting to load BIOS image from PRAMIN
[drm] nouveau 0000:01:00.0: ... appears to be valid
[drm] nouveau 0000:01:00.0: BIT BIOS found
[drm] nouveau 0000:01:00.0: Bios version 60.80.13.00
[drm] nouveau 0000:01:00.0: TMDS table version 2.0
[drm] nouveau 0000:01:00.0: BIT table 'd' not found
[drm] nouveau 0000:01:00.0: Found Display Configuration Block version 4.0
[drm] nouveau 0000:01:00.0: Raw DCB entry 0: 04000320 00000028
[drm] nouveau 0000:01:00.0: Raw DCB entry 1: 01000322 00000030
[drm] nouveau 0000:01:00.0: Raw DCB entry 2: 02011310 00000028
[drm] nouveau 0000:01:00.0: Raw DCB entry 3: 02011312 00000030
[drm] nouveau 0000:01:00.0: Raw DCB entry 4: 010223f1 00c1c020
[drm] nouveau 0000:01:00.0: DCB connector table: VHER 0x40 5 6 2
[drm] nouveau 0000:01:00.0:   0: 0x00001030: type 0x30 idx 0 tag 0x07
[drm] nouveau 0000:01:00.0:   1: 0x00002130: type 0x30 idx 1 tag 0x08
[drm] nouveau 0000:01:00.0:   2: 0x00000210: type 0x10 idx 2 tag 0xff
[drm] nouveau 0000:01:00.0:   3: 0x00000211: type 0x11 idx 3 tag 0xff
[drm] nouveau 0000:01:00.0:   4: 0x00000213: type 0x13 idx 4 tag 0xff
[drm] nouveau 0000:01:00.0: Parsing VBIOS init table 0 at offset 0xBC7E
[drm] nouveau 0000:01:00.0: Parsing VBIOS init table 1 at offset 0xBE86
[drm] nouveau 0000:01:00.0: Parsing VBIOS init table 2 at offset 0xD041
[drm] nouveau 0000:01:00.0: Parsing VBIOS init table 3 at offset 0xD130
[drm] nouveau 0000:01:00.0: Parsing VBIOS init table 4 at offset 0xD2E7
[drm] nouveau 0000:01:00.0: Parsing VBIOS init table at offset 0xD34C
[drm] nouveau 0000:01:00.0: 0xD34C: Condition still not met after 20ms, skipping following opcodes
[drm] nouveau 0000:01:00.0: 1 available performance level(s)
[drm] nouveau 0000:01:00.0: 0: memory 900MHz core 576MHz shader 1350MHz voltage 1300mV fanspeed 100%
[drm] nouveau 0000:01:00.0: c: memory 396MHz core 198MHz shader 1188MHz
[TTM] Zone  kernel: Available graphics memory: 4074414 kiB.
[TTM] Zone   dma32: Available graphics memory: 2097152 kiB.
[TTM] Initializing pool allocator.
[drm] nouveau 0000:01:00.0: Detected 768MiB VRAM
mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combining
[drm] nouveau 0000:01:00.0: 512 MiB GART (aperture)
[drm] nouveau 0000:01:00.0: DCB encoder 1 unknown
[drm] nouveau 0000:01:00.0: TV-1 has no encoders, removing
[drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[drm] No driver support for vblank timestamp query.

=========================================================
[ INFO: possible irq lock inversion dependency detected ]
2.6.38-rc8 #9
---------------------------------------------------------
kworker/0:1/0 just changed the state of lock:
 (&(&dev_priv->context_switch_lock)->rlock){-.....}, at: [<ffffffff812a6727>] nouveau_irq_handler+0x57/0x150
but this lock took another, HARDIRQ-unsafe lock in the past:
 (&(&dev_priv->ramin_lock)->rlock){+.+...}

and interrupts could create inverse lock ordering between them.


other info that might help us debug this:
no locks held by kworker/0:1/0.

the shortest dependencies between 2nd lock and 1st lock:
 -> (&(&dev_priv->ramin_lock)->rlock){+.+...} ops: 24866 {
    HARDIRQ-ON-W at:
                                         [<ffffffff8109ba2e>] __lock_acquire+0xbee/0x1c40
                                         [<ffffffff8109cada>] lock_acquire+0x5a/0x70
                                         [<ffffffff814c5846>] _raw_spin_lock+0x36/0x50
                                         [<ffffffff812a555b>] nouveau_gpuobj_new+0xab/0x2e0
                                         [<ffffffff813011de>] nv50_instmem_init+0x12e/0x6d0
                                         [<ffffffff812a0c86>] nouveau_card_init+0x446/0x1680
                                         [<ffffffff812a22f3>] nouveau_load+0x433/0x700
                                         [<ffffffff8128b08a>] drm_get_pci_dev+0x18a/0x2a0
                                         [<ffffffff814bf023>] nouveau_pci_probe+0x10/0x12
                                         [<ffffffff8120ffe2>] local_pci_probe+0x12/0x20
                                         [<ffffffff812102a0>] pci_device_probe+0x80/0xb0
                                         [<ffffffff81325c09>] driver_probe_device+0x89/0x1a0
                                         [<ffffffff81325dbb>] __driver_attach+0x9b/0xa0
                                         [<ffffffff813252f8>] bus_for_each_dev+0x68/0x90
                                         [<ffffffff81325a49>] driver_attach+0x19/0x20
                                         [<ffffffff81324b68>] bus_add_driver+0x1a8/0x270
                                         [<ffffffff813260a8>] driver_register+0x78/0x140
                                         [<ffffffff81210521>] __pci_register_driver+0x61/0xe0
                                         [<ffffffff8128b26a>] drm_pci_init+0xca/0xe0
                                         [<ffffffff81283f13>] drm_init+0x53/0x70
                                         [<ffffffff818fc779>] nouveau_init+0x48/0x4a
                                         [<ffffffff818de5f6>] do_one_initcall+0x7a/0x12e
                                         [<ffffffff818de80c>] kernel_init+0x142/0x1c6
                                         [<ffffffff81032f14>] kernel_thread_helper+0x4/0x10
    SOFTIRQ-ON-W at:
                                         [<ffffffff8109ba64>] __lock_acquire+0xc24/0x1c40
                                         [<ffffffff8109cada>] lock_acquire+0x5a/0x70
                                         [<ffffffff814c5846>] _raw_spin_lock+0x36/0x50
                                         [<ffffffff812a555b>] nouveau_gpuobj_new+0xab/0x2e0
                                         [<ffffffff813011de>] nv50_instmem_init+0x12e/0x6d0
                                         [<ffffffff812a0c86>] nouveau_card_init+0x446/0x1680
                                         [<ffffffff812a22f3>] nouveau_load+0x433/0x700
                                         [<ffffffff8128b08a>] drm_get_pci_dev+0x18a/0x2a0
                                         [<ffffffff814bf023>] nouveau_pci_probe+0x10/0x12
                                         [<ffffffff8120ffe2>] local_pci_probe+0x12/0x20
                                         [<ffffffff812102a0>] pci_device_probe+0x80/0xb0
                                         [<ffffffff81325c09>] driver_probe_device+0x89/0x1a0
                                         [<ffffffff81325dbb>] __driver_attach+0x9b/0xa0
                                         [<ffffffff813252f8>] bus_for_each_dev+0x68/0x90
                                         [<ffffffff81325a49>] driver_attach+0x19/0x20
                                         [<ffffffff81324b68>] bus_add_driver+0x1a8/0x270
                                         [<ffffffff813260a8>] driver_register+0x78/0x140
                                         [<ffffffff81210521>] __pci_register_driver+0x61/0xe0
                                         [<ffffffff8128b26a>] drm_pci_init+0xca/0xe0
                                         [<ffffffff81283f13>] drm_init+0x53/0x70
                                         [<ffffffff818fc779>] nouveau_init+0x48/0x4a
                                         [<ffffffff818de5f6>] do_one_initcall+0x7a/0x12e
                                         [<ffffffff818de80c>] kernel_init+0x142/0x1c6
                                         [<ffffffff81032f14>] kernel_thread_helper+0x4/0x10
    INITIAL USE at:
                                        [<ffffffff8109b2fb>] __lock_acquire+0x4bb/0x1c40
                                        [<ffffffff8109cada>] lock_acquire+0x5a/0x70
                                        [<ffffffff814c5846>] _raw_spin_lock+0x36/0x50
                                        [<ffffffff812a555b>] nouveau_gpuobj_new+0xab/0x2e0
                                        [<ffffffff813011de>] nv50_instmem_init+0x12e/0x6d0
                                        [<ffffffff812a0c86>] nouveau_card_init+0x446/0x1680
                                        [<ffffffff812a22f3>] nouveau_load+0x433/0x700
                                        [<ffffffff8128b08a>] drm_get_pci_dev+0x18a/0x2a0
                                        [<ffffffff814bf023>] nouveau_pci_probe+0x10/0x12
                                        [<ffffffff8120ffe2>] local_pci_probe+0x12/0x20
                                        [<ffffffff812102a0>] pci_device_probe+0x80/0xb0
                                        [<ffffffff81325c09>] driver_probe_device+0x89/0x1a0
                                        [<ffffffff81325dbb>] __driver_attach+0x9b/0xa0
                                        [<ffffffff813252f8>] bus_for_each_dev+0x68/0x90
                                        [<ffffffff81325a49>] driver_attach+0x19/0x20
                                        [<ffffffff81324b68>] bus_add_driver+0x1a8/0x270
                                        [<ffffffff813260a8>] driver_register+0x78/0x140
                                        [<ffffffff81210521>] __pci_register_driver+0x61/0xe0
                                        [<ffffffff8128b26a>] drm_pci_init+0xca/0xe0
                                        [<ffffffff81283f13>] drm_init+0x53/0x70
                                        [<ffffffff818fc779>] nouveau_init+0x48/0x4a
                                        [<ffffffff818de5f6>] do_one_initcall+0x7a/0x12e
                                        [<ffffffff818de80c>] kernel_init+0x142/0x1c6
                                        [<ffffffff81032f14>] kernel_thread_helper+0x4/0x10
  }
  ... key      at: [<ffffffff822bd7b8>] __key.40392+0x0/0x8
  ... acquired at:
   [<ffffffff8109cada>] lock_acquire+0x5a/0x70
   [<ffffffff814c5846>] _raw_spin_lock+0x36/0x50
   [<ffffffff81300bbd>] nv50_instmem_flush+0x1d/0x90
   [<ffffffff812d2050>] nv50_fifo_create_context+0x260/0x340
   [<ffffffff812a2f9d>] nouveau_channel_alloc+0x33d/0x6d0
   [<ffffffff812a0dea>] nouveau_card_init+0x5aa/0x1680
   [<ffffffff812a22f3>] nouveau_load+0x433/0x700
   [<ffffffff8128b08a>] drm_get_pci_dev+0x18a/0x2a0
   [<ffffffff814bf023>] nouveau_pci_probe+0x10/0x12
   [<ffffffff8120ffe2>] local_pci_probe+0x12/0x20
   [<ffffffff812102a0>] pci_device_probe+0x80/0xb0
   [<ffffffff81325c09>] driver_probe_device+0x89/0x1a0
   [<ffffffff81325dbb>] __driver_attach+0x9b/0xa0
   [<ffffffff813252f8>] bus_for_each_dev+0x68/0x90
   [<ffffffff81325a49>] driver_attach+0x19/0x20
   [<ffffffff81324b68>] bus_add_driver+0x1a8/0x270
   [<ffffffff813260a8>] driver_register+0x78/0x140
   [<ffffffff81210521>] __pci_register_driver+0x61/0xe0
   [<ffffffff8128b26a>] drm_pci_init+0xca/0xe0
   [<ffffffff81283f13>] drm_init+0x53/0x70
   [<ffffffff818fc779>] nouveau_init+0x48/0x4a
   [<ffffffff818de5f6>] do_one_initcall+0x7a/0x12e
   [<ffffffff818de80c>] kernel_init+0x142/0x1c6
   [<ffffffff81032f14>] kernel_thread_helper+0x4/0x10

-> (&(&dev_priv->context_switch_lock)->rlock){-.....} ops: 6 {
   IN-HARDIRQ-W at:
                                       [<ffffffff8109bb7c>] __lock_acquire+0xd3c/0x1c40
                                       [<ffffffff8109cada>] lock_acquire+0x5a/0x70
                                       [<ffffffff814c5961>] _raw_spin_lock_irqsave+0x41/0x60
                                       [<ffffffff812a6727>] nouveau_irq_handler+0x57/0x150
                                       [<ffffffff810adfca>] handle_IRQ_event+0x3a/0xe0
                                       [<ffffffff810b0778>] handle_fasteoi_irq+0x78/0x100
                                       [<ffffffff81034e3d>] handle_irq+0x1d/0x30
                                       [<ffffffff81034338>] do_IRQ+0x58/0xd0
                                       [<ffffffff814c66d3>] ret_from_intr+0x0/0x13
                                       [<ffffffff8103129b>] cpu_idle+0xab/0x110
                                       [<ffffffff8190ab59>] start_secondary+0x1e2/0x1e9
   INITIAL USE at:
                                      [<ffffffff8109b2fb>] __lock_acquire+0x4bb/0x1c40
                                      [<ffffffff8109cada>] lock_acquire+0x5a/0x70
                                      [<ffffffff814c5961>] _raw_spin_lock_irqsave+0x41/0x60
                                      [<ffffffff812a667a>] nouveau_irq_register+0x3a/0x70
                                      [<ffffffff8131b8ed>] nv50_gpio_init+0x7d/0x130
                                      [<ffffffff812a0cc3>] nouveau_card_init+0x483/0x1680
                                      [<ffffffff812a22f3>] nouveau_load+0x433/0x700
                                      [<ffffffff8128b08a>] drm_get_pci_dev+0x18a/0x2a0
                                      [<ffffffff814bf023>] nouveau_pci_probe+0x10/0x12
                                      [<ffffffff8120ffe2>] local_pci_probe+0x12/0x20
                                      [<ffffffff812102a0>] pci_device_probe+0x80/0xb0
                                      [<ffffffff81325c09>] driver_probe_device+0x89/0x1a0
                                      [<ffffffff81325dbb>] __driver_attach+0x9b/0xa0
                                      [<ffffffff813252f8>] bus_for_each_dev+0x68/0x90
                                      [<ffffffff81325a49>] driver_attach+0x19/0x20
                                      [<ffffffff81324b68>] bus_add_driver+0x1a8/0x270
                                      [<ffffffff813260a8>] driver_register+0x78/0x140
                                      [<ffffffff81210521>] __pci_register_driver+0x61/0xe0
                                      [<ffffffff8128b26a>] drm_pci_init+0xca/0xe0
                                      [<ffffffff81283f13>] drm_init+0x53/0x70
                                      [<ffffffff818fc779>] nouveau_init+0x48/0x4a
                                      [<ffffffff818de5f6>] do_one_initcall+0x7a/0x12e
                                      [<ffffffff818de80c>] kernel_init+0x142/0x1c6
                                      [<ffffffff81032f14>] kernel_thread_helper+0x4/0x10
 }
 ... key      at: [<ffffffff822bd798>] __key.41016+0x0/0x8
 ... acquired at:
   [<ffffffff81099cd2>] check_usage_forwards+0xa2/0x110
   [<ffffffff810990b7>] mark_lock+0x1f7/0x630
   [<ffffffff8109bb7c>] __lock_acquire+0xd3c/0x1c40
   [<ffffffff8109cada>] lock_acquire+0x5a/0x70
   [<ffffffff814c5961>] _raw_spin_lock_irqsave+0x41/0x60
   [<ffffffff812a6727>] nouveau_irq_handler+0x57/0x150
   [<ffffffff810adfca>] handle_IRQ_event+0x3a/0xe0
   [<ffffffff810b0778>] handle_fasteoi_irq+0x78/0x100
   [<ffffffff81034e3d>] handle_irq+0x1d/0x30
   [<ffffffff81034338>] do_IRQ+0x58/0xd0
   [<ffffffff814c66d3>] ret_from_intr+0x0/0x13
   [<ffffffff8103129b>] cpu_idle+0xab/0x110
   [<ffffffff8190ab59>] start_secondary+0x1e2/0x1e9


stack backtrace:
Pid: 0, comm: kworker/0:1 Not tainted 2.6.38-rc8 #9
Call Trace:
 <IRQ>  [<ffffffff81099c09>] ? print_irq_inversion_bug+0x139/0x160
 [<ffffffff81099c30>] ? check_usage_forwards+0x0/0x110
 [<ffffffff81099cd2>] ? check_usage_forwards+0xa2/0x110
 [<ffffffff810990b7>] ? mark_lock+0x1f7/0x630
 [<ffffffff8109bb7c>] ? __lock_acquire+0xd3c/0x1c40
 [<ffffffff8109b2fb>] ? __lock_acquire+0x4bb/0x1c40
 [<ffffffff81099755>] ? trace_hardirqs_on_caller+0x65/0x180
 [<ffffffff810b244a>] ? check_for_new_grace_period+0xaa/0x120
 [<ffffffff8109cada>] ? lock_acquire+0x5a/0x70
 [<ffffffff812a6727>] ? nouveau_irq_handler+0x57/0x150
 [<ffffffff814c5961>] ? _raw_spin_lock_irqsave+0x41/0x60
 [<ffffffff812a6727>] ? nouveau_irq_handler+0x57/0x150
 [<ffffffff812a6727>] ? nouveau_irq_handler+0x57/0x150
 [<ffffffff810adfca>] ? handle_IRQ_event+0x3a/0xe0
 [<ffffffff810b0778>] ? handle_fasteoi_irq+0x78/0x100
 [<ffffffff81034e3d>] ? handle_irq+0x1d/0x30
 [<ffffffff81034338>] ? do_IRQ+0x58/0xd0
 [<ffffffff814c66d3>] ? ret_from_intr+0x0/0x13
 <EOI>  [<ffffffff8103a749>] ? mwait_idle+0x89/0xc0
 [<ffffffff8103a740>] ? mwait_idle+0x80/0xc0
 [<ffffffff8103129b>] ? cpu_idle+0xab/0x110
 [<ffffffff8190ab59>] ? start_secondary+0x1e2/0x1e9
[drm] nouveau 0000:01:00.0: allocated 1280x1024 fb: 0x60000000, bo ffff88023f6e9120
Console: switching to colour frame buffer device 160x64
fb0: nouveaufb frame buffer device
drm: registered panic notifier
[drm] Initialized nouveau 0.0.16 20090420 for 0000:01:00.0 on minor 0
	...
