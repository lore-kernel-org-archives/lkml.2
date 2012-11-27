Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209Ab2K0Q3i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 11:29:38 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:42720 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755591Ab2K0Q3h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 11:29:37 -0500
MIME-Version: 1.0
Date: Tue, 27 Nov 2012 17:29:36 +0100
Message-ID: <CADDKRnDBHhqDzZVgB-8gv366OWKkamM9wR0+OcyfdX0kp_fKdA@mail.gmail.com>
Subject: [v3.7-rcx] drm/i915: *ERROR* Timed out waiting for forcewake old ack
 to clear
From: =?ISO-8859-1?Q?J=F6rg_Otte?= <jrg.otte@gmail.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At boot-up with newer kernels (at least v3.6.x, v3.7-rc) I always see
following on the bootup-display:

3.7-rcx: [drm:__gen6_gt_force_wake_mt_get] *ERROR* Timed out waiting
for forcewake old ack to clear.
3.6.x:    [drm:__gen6_gt_force_wake_mt_get] *ERROR* Force wake wait timed out

It's an Ivy Bridge/64Bit Notebook.

I know there is a patch at
http://www.mail-archive.com/intel-gfx@lists.freedesktop.org/msg14602.html
but it doesn't apply to v3.7-rcx.

This does not occur with the distro kernel (kubuntu, kernel 3.2.29).

Jörg.

Please  CC me, I am not subsribed

---
$ lspci
00:00.0 Host bridge: Intel Corporation Ivy Bridge DRAM Controller (rev 09)
00:02.0 VGA compatible controller: Intel Corporation Ivy Bridge
Graphics Controller (rev 09)
00:14.0 USB controller: Intel Corporation Panther Point USB xHCI Host
Controller (rev 04)
00:16.0 Communication controller: Intel Corporation Panther Point MEI
Controller #1 (rev 04)
00:1a.0 USB controller: Intel Corporation Panther Point USB Enhanced
Host Controller #2 (rev 04)
00:1b.0 Audio device: Intel Corporation Panther Point High Definition
Audio Controller (rev 04)
00:1c.0 PCI bridge: Intel Corporation Panther Point PCI Express Root
Port 1 (rev c4)
00:1c.2 PCI bridge: Intel Corporation Panther Point PCI Express Root
Port 3 (rev c4)
00:1c.4 PCI bridge: Intel Corporation Panther Point PCI Express Root
Port 5 (rev c4)
00:1c.5 PCI bridge: Intel Corporation Panther Point PCI Express Root
Port 6 (rev c4)
00:1d.0 USB controller: Intel Corporation Panther Point USB Enhanced
Host Controller #1 (rev 04)
00:1f.0 ISA bridge: Intel Corporation Panther Point LPC Controller (rev 04)
00:1f.2 SATA controller: Intel Corporation Panther Point 6 port SATA
Controller [AHCI mode] (rev 04)
00:1f.3 SMBus: Intel Corporation Panther Point SMBus Controller (rev 04)
02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 07)
08:00.0 Network controller: Intel Corporation Centrino Wireless-N 2230 (rev c4)

$ lspci -vs 00:02.0
00:02.0 VGA compatible controller: Intel Corporation Ivy Bridge
Graphics Controller (rev 09) (prog-if 00 [VGA controller])
        Subsystem: Fujitsu Limited. Device 16c2
        Flags: bus master, fast devsel, latency 0, IRQ 40
        Memory at f0000000 (64-bit, non-prefetchable) [size=4M]
        Memory at e0000000 (64-bit, prefetchable) [size=256M]
        I/O ports at 4000 [size=64]
        Expansion ROM at <unassigned> [disabled]
        Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
        Capabilities: [d0] Power Management version 2
        Capabilities: [a4] PCI Advanced Features
        Kernel driver in use: i915
