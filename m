Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751031Ab0LOIdw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 03:33:52 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46101 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862Ab0LOIdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 03:33:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=U7G6nLpjpyL2pXRNd7KQS76935gzx+d5bfm2BOKR/IZuYAVTVAms63LZ+cGMuLebSF
         9AoTgiXuedPbcpDPe0A3Jnp6tkCzgesEB3qaiFe+vcXfdT8kiDfI0d4Pg/Y8KJh4SqoI
         A0iXFVMi94p+go2AOBbO3zVJL9RxnB58zOEPc=
MIME-Version: 1.0
From: Hui Zhu <teawater@gmail.com>
Date: Wed, 15 Dec 2010 16:33:29 +0800
Message-ID: <AANLkTimOOmFqxU=r+-RphdfPJ54Qr+6LHU60Grzpnerr@mail.gmail.com>
Subject: [BUG] i915 boot got black screen with 2.6.37-rc5+
To: linux-kernel@vger.kernel.org
Cc: keithp@keithp.com, ak@linux.intel.com, chris@chris-wilson.co.uk,
        gregkh@suse.de, stable@kernel.org, Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The right log with 2.6.37-rc3+:
Dec 15 16:13:03 teawater-workpc kernel: [ 14.569871] [drm] Initialized
drm 1.1.0 20060810
Dec 15 16:13:03 teawater-workpc kernel: [ 14.882768] i915
0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Dec 15 16:13:03 teawater-workpc kernel: [ 14.882775] i915
0000:00:02.0: setting latency timer to 64
Dec 15 16:13:03 teawater-workpc kernel: [ 14.894778] mtrr: type
mismatch for d0000000,10000000 old: write-back new: write-combining
Dec 15 16:13:03 teawater-workpc kernel: [ 14.894781] [drm] MTRR
allocation failed. Graphics performance may suffer.
Dec 15 16:13:03 teawater-workpc kernel: [ 14.895367] i915
0000:00:02.0: irq 43 for MSI/MSI-X
Dec 15 16:13:03 teawater-workpc kernel: [ 14.895610] vgaarb: device
changed decodes:
PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
Dec 15 16:13:03 teawater-workpc kernel: [ 14.895927] [drm] initialized
overlay support
Dec 15 16:13:03 teawater-workpc kernel: [ 14.981492] Console:
switching to colour frame buffer device 210x65
Dec 15 16:13:03 teawater-workpc kernel: [ 14.986676] fb0: inteldrmfb
frame buffer device
Dec 15 16:13:03 teawater-workpc kernel: [ 14.986678] drm: registered
panic notifier
Dec 15 16:13:03 teawater-workpc kernel: [ 14.986761] [drm] Initialized
i915 1.6.0 20080730 for 0000:00:02.0 on minor 0

The black log with 2.6.37-rc5+:
Dec 15 16:10:51 teawater-workpc kernel: [ 12.418419] [drm] Initialized
drm 1.1.0 20060810
Dec 15 16:10:51 teawater-workpc kernel: [ 12.945240] i915
0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Dec 15 16:10:51 teawater-workpc kernel: [ 12.945246] i915
0000:00:02.0: setting latency timer to 64
Dec 15 16:10:51 teawater-workpc kernel: [ 12.957555] mtrr: type
mismatch for d0000000,10000000 old: write-back new: write-combining
Dec 15 16:10:51 teawater-workpc kernel: [ 12.957559] [drm] MTRR
allocation failed. Graphics performance may suffer.
Dec 15 16:10:51 teawater-workpc kernel: [ 12.958502] i915
0000:00:02.0: irq 42 for MSI/MSI-X
Dec 15 16:10:51 teawater-workpc kernel: [ 12.958806] vgaarb: device
changed decodes:
PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
Dec 15 16:10:51 teawater-workpc kernel: [ 12.959124] [drm] initialized
overlay support
Dec 15 16:10:51 teawater-workpc kernel: [ 13.980020] No connectors
reported connected with modes
Dec 15 16:10:51 teawater-workpc kernel: [ 13.980025] [drm] Cannot find
any crtc or sizes - going 1024x768
Dec 15 16:10:51 teawater-workpc kernel: [ 13.986063] Console:
switching to colour frame buffer device 128x48
Dec 15 16:10:51 teawater-workpc kernel: [ 13.988296] fb0: inteldrmfb
frame buffer device
Dec 15 16:10:51 teawater-workpc kernel: [ 13.988298] drm: registered
panic notifier
Dec 15 16:10:51 teawater-workpc kernel: [ 13.988425] [drm] Initialized
i915 1.6.0 20080730 for 0000:00:02.0 on minor 0

Thanks,
Hui
