Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906Ab1FPQ00 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 12:26:26 -0400
Received: from alerce.vps.bitfolk.com ([212.13.194.134]:44475 "EHLO
	alerce.vps.bitfolk.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755127Ab1FPQ0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 12:26:24 -0400
Date: Thu, 16 Jun 2011 11:58:42 -0300
From: Leandro Lucarella <luca@llucax.com.ar>
To: dri-devel@lists.freedesktop.org, kernel@vger.kernel.org,
        David Airlie <airlied@linux.ie>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org
Subject: Graphic corruption with i915 (2.6.39.1)
Message-ID: <20110616145842.GM20487@llucax.com.ar>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Paranoid: Just because you're paranoid, don't mean they're not after you.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, I've been experiencing sporadic graphic corruption since a few
stable kernel versions and I always thought "maybe is fixed in the next
release", so I upgrade, but I usually experience a different problem
then. This problems are exposed very rarely, maybe I have no problems
like for a month or so.

Now I'm using kernel 2.6.39.1 and I experience one of this problem so
I though it was time to report it. This is what I got in dmesg:

[368693.756008] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung
[368693.756014] render error detected, EIR: 0x00000010
[368693.756017]   IPEIR: 0x00000000
[368693.756019]   IPEHR: 0x02000004
[368693.756020]   INSTDONE: 0xcc8fffff
[368693.756022]   INSTPS: 0x8001e025
[368693.756024]   INSTDONE1: 0xbfffffbf
[368693.756026]   ACTHD: 0x00715128
[368693.756027] page table error
[368693.756029]   PGTBL_ER: 0x00000002
[368693.756038] [drm:i915_wait_request] *ERROR* i915_wait_request returns -11 (awaiting 17700193 at 17700192, next 17700196)
[368694.258010] [drm:i915_reset] *ERROR* Failed to reset chip.

Here are 2 images of my desktop, without the graphic corruption first
and with the corruption then: http://imgur.com/a/NX7te

# lspci 
00:00.0 Host bridge: Intel Corporation 4 Series Chipset DRAM Controller (rev 03)
00:01.0 PCI bridge: Intel Corporation 4 Series Chipset PCI Express Root Port (rev 03)
00:02.0 VGA compatible controller: Intel Corporation 4 Series Chipset Integrated Graphics Controller (rev 03)
00:1b.0 Audio device: Intel Corporation N10/ICH 7 Family High Definition Audio Controller (rev 01)
00:1c.0 PCI bridge: Intel Corporation N10/ICH 7 Family PCI Express Port 1 (rev 01)
00:1c.1 PCI bridge: Intel Corporation N10/ICH 7 Family PCI Express Port 2 (rev 01)
00:1d.0 USB Controller: Intel Corporation N10/ICH 7 Family USB UHCI Controller #1 (rev 01)
00:1d.1 USB Controller: Intel Corporation N10/ICH 7 Family USB UHCI Controller #2 (rev 01)
00:1d.2 USB Controller: Intel Corporation N10/ICH 7 Family USB UHCI Controller #3 (rev 01)
00:1d.3 USB Controller: Intel Corporation N10/ICH 7 Family USB UHCI Controller #4 (rev 01)
00:1d.7 USB Controller: Intel Corporation N10/ICH 7 Family USB2 EHCI Controller (rev 01)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev e1)
00:1f.0 ISA bridge: Intel Corporation 82801GB/GR (ICH7 Family) LPC Interface Bridge (rev 01)
00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE Controller (rev 01)
00:1f.2 IDE interface: Intel Corporation N10/ICH7 Family SATA IDE Controller (rev 01)
00:1f.3 SMBus: Intel Corporation N10/ICH 7 Family SMBus Controller (rev 01)
03:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 03)
04:00.0 Multimedia video controller: Brooktree Corporation Bt848 Video Capture (rev 12)

Any ideas on what might be going on and how to fix it are welcome. Please let
me know if you need any other information.

Thanks in advance.

-- 
Leandro Lucarella (AKA luca)                     http://llucax.com.ar/
----------------------------------------------------------------------
GPG Key: 5F5A8D05 (F8CD F9A7 BF00 5431 4145  104C 949E BFB6 5F5A 8D05)
----------------------------------------------------------------------
SEÑOR BIELSA: CON TODO RESPETO ¿USTED LO VE JUGAR A RIQUELME?
	-- Crónica TV
