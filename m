Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932341Ab0FKUbM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 16:31:12 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:32798 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754894Ab0FKUbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 16:31:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=Gyb0A3VFtCWYLN/bfxwncuttcs8eB/lMhbfg0pUnnsc8cpIU56QoHNq3n8r0pJQz7w
         Wc9/YcwBX8W9zIMbrYyLhDeSbNNSV6wjEmQ8wfLgDv2fp60ew1e+KQE82NWRds8xgvCN
         cWbFmlPs/oU7M/+yufz042b0PGr7PnojXo434=
MIME-Version: 1.0
Date: Fri, 11 Jun 2010 16:31:08 -0400
Message-ID: <AANLkTim0jVRyqkwlGOcrg_XTvUQwcBYfWJX-aRzkkrLG@mail.gmail.com>
Subject: 2.6.35-rc2-git5 -- [drm:drm_mode_getfb] *ERROR* invalid framebuffer 
	id
From: Miles Lane <miles.lane@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, David Airlie <airlied@linux.ie>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

# dmesg | grep -i drm
How should I go about debugging this?  I am running Ubuntu unstable,
which just moved to the latest Xorg code (xserver-xorg-core
2:1.8.1.901-1ubuntu1 and  xserver-xorg-video-intel 2:2.11.0-1ubuntu2
).

[    0.971549] [drm] Initialized drm 1.1.0 20060810
[    1.171050] [drm] set up 31M of stolen space
[    2.075347] fb0: inteldrmfb frame buffer device
[    2.075351] drm: registered panic notifier
[    2.081609] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[   66.545581] [drm:drm_mode_getfb] *ERROR* invalid framebuffer id
[   75.336738] [drm:drm_mode_getfb] *ERROR* invalid framebuffer id
[30843.394355] [drm:drm_mode_getfb] *ERROR* invalid framebuffer id
[33302.610229] [drm:init_ring_common] *ERROR* render ring head not
reset to zero ctl 00000000 head fffffffc tail 00000000 start 02000000
[33302.610238] [drm:init_ring_common] *ERROR* render ring head forced
to zero ctl 00000000 head 00000000 tail 00000000 start 02000000
[33305.239941] [drm:drm_mode_getfb] *ERROR* invalid framebuffer id
[35339.052446] [drm:drm_mode_getfb] *ERROR* invalid framebuffer id

00:02.0 VGA compatible controller: Intel Corporation Mobile 4 Series
Chipset Integrated Graphics Controller (rev 07)
	Subsystem: ASUSTeK Computer Inc. Device 1af2
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 44
	Region 0: Memory at fcc00000 (64-bit, non-prefetchable) [size=4M]
	Region 2: Memory at d0000000 (64-bit, prefetchable) [size=256M]
	Region 4: I/O ports at cc00 [size=8]
	Capabilities: [90] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
		Address: fee0200c  Data: 4169
	Capabilities: [d0] Power Management version 3
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: i915
00: 86 80 42 2a 07 04 90 00 07 00 00 03 00 00 00 00
10: 04 00 c0 fc 00 00 00 00 0c 00 00 d0 00 00 00 00
20: 01 cc 00 00 00 00 00 00 00 00 00 00 43 10 f2 1a
30: 00 00 00 00 90 00 00 00 00 00 00 00 0a 01 00 00
40: 00 00 00 00 48 00 00 00 09 00 0a 11 88 30 00 1c
50: 01 80 50 03 0b 00 00 00 00 00 00 00 00 00 00 be
60: 00 00 00 00 00 00 02 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 05 d0 01 00 0c 20 e0 fe 69 41 00 00 00 00 00 00
a0: 00 00 00 00 09 00 06 20 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 40 01 00 00
d0: 01 00 23 00 00 00 00 00 00 00 00 00 34 00 00 00
e0: 00 00 00 00 00 00 00 00 00 80 00 1a 41 20 00 00
f0: 0d 1c 34 07 ff 00 00 00 a0 0f 07 00 e4 20 d8 bd

01:00.0 VGA compatible controller: nVidia Corporation GT218 [GeForce
G210M] (rev a2)
	Subsystem: ASUSTeK Computer Inc. Device 1af2
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at fd000000 (32-bit, non-prefetchable) [disabled] [size=16M]
	Region 1: Memory at e0000000 (64-bit, prefetchable) [disabled] [size=256M]
	Region 3: Memory at fa000000 (64-bit, prefetchable) [disabled] [size=32M]
	Region 5: I/O ports at dc00 [disabled] [size=128]
	Expansion ROM at fe980000 [disabled] [size=512K]
	Capabilities: [60] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [68] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [78] Express (v2) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, L1 <64us
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 5GT/s, Width x16, ASPM L0s L1, Latency L0
<256ns, L1 <1us
			ClockPM+ Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM L0s L1 Enabled; RCB 128 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x8, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
	Capabilities: [b4] Vendor Specific Information <?>
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [128] Power Budgeting <?>
	Capabilities: [600] Vendor Specific Information <?>
00: de 10 74 0a 00 00 10 00 a2 00 00 03 08 00 80 00
10: 00 00 00 fd 0c 00 00 e0 00 00 00 00 0c 00 00 fa
20: 00 00 00 00 01 dc 00 00 00 00 00 00 43 10 f2 1a
30: 00 00 98 fe 60 00 00 00 00 00 00 00 0a 01 00 00
40: 43 10 f2 1a 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 01 00 00 00 ce d6 23 00 00 00 00 00
60: 01 68 03 00 08 00 00 00 05 78 80 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 10 b4 02 00 a0 8d 64 00
80: 10 28 00 00 02 2d 04 00 4b 00 81 10 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 10 00 00 00
a0: 00 00 00 00 00 00 00 00 02 00 00 00 00 00 00 00
b0: 00 00 00 00 09 00 14 01 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

CONFIG_AGP=y
CONFIG_AGP_INTEL=y
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=2
CONFIG_VGA_SWITCHEROO=y
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_I915=y
CONFIG_DRM_I915_KMS=y
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y
CONFIG_XEN_FBDEV_FRONTEND=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
CONFIG_LCD_PLATFORM=m
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
