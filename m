Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757872Ab1IHCCk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 22:02:40 -0400
Received: from tn-76-7-162-101.sta.embarqhsd.net ([76.7.162.101]:55919 "EHLO
	animx.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757835Ab1IHCCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 22:02:38 -0400
X-Greylist: delayed 688 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Sep 2011 22:02:38 EDT
Date: Wed, 7 Sep 2011 22:02:35 -0400
From: Wakko Warner <wakko@animx.eu.org>
To: linux-kernel@vger.kernel.org
Subject: Re: radeon KMS (R100) on dell inspiron 5100 blank screen
Message-ID: <20110908020235.GA582@animx.eu.org>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <20110908015105.GA31062@animx.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110908015105.GA31062@animx.eu.org>
User-Agent: Mutt/1.5.6+20040907i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My previous message, I stated in the subject line that this was a 5150. 
This is an inspiron 5100.

Wakko Warner wrote:
> I have fbcon compiled into the kernel, radeon as a module.  I have no
> framebuffer modules compiled.  The KMS has never worked on this system with
> any kernel I've compiled (2.6.33 and up).
> 
> Here's the relevent dmesg:
> 
> [drm] radeon defaulting to kernel modesetting.
> [drm] radeon kernel modesetting enabled.
> [drm] initializing kernel modesetting (RV200 0x1002:0x4C57).
> [drm] register mmio base: 0xFCFF0000
> [drm] register mmio size: 65536
> radeon 0000:01:00.0: Invalid ROM contents
> radeon 0000:01:00.0: Invalid ROM contents
> [drm:radeon_get_bios] *ERROR* Unable to locate a BIOS ROM
> [drm] Using generic clock info
> agpgart-intel 0000:00:00.0: AGP 2.0 bridge
> agpgart-intel 0000:00:00.0: putting AGP V2 device into 4x mode
> radeon 0000:01:00.0: putting AGP V2 device into 4x mode
> radeon 0000:01:00.0: GTT: 128M 0xE0000000 - 0xE7FFFFFF
> radeon 0000:01:00.0: VRAM: 128M 0x00000000E8000000 - 0x00000000EFFFFFFF (32M used)
> [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
> [drm] Driver supports precise vblank timestamp query.
> [drm] radeon: irq initialized.
> [drm] Detected VRAM RAM=128M, BAR=128M
> [drm] RAM width 64bits DDR
> [TTM] Zone  kernel: Available graphics memory: 443880 kiB.
> [TTM] Zone highmem: Available graphics memory: 1037694 kiB.
> [TTM] Initializing pool allocator.
> [drm] radeon: 32M of VRAM memory ready
> [drm] radeon: 128M of GTT memory ready.
> radeon 0000:01:00.0: WB disabled
> [drm] Loading R100 Microcode
> [drm] radeon: ring at 0x00000000E0001000
> [drm] ring test succeeded in 1 usecs
> [drm] radeon: ib pool ready.
> [drm] ib test succeeded in 0 usecs
> [drm] Connector Table: 1 (generic)
> [drm] No panel info found in BIOS
> [drm] Panel info derived from registers
> [drm] Panel Size 1400x1050
> [drm] radeon legacy LVDS backlight initialized
> [drm] No TV DAC info found in BIOS
> [drm] Radeon Display Connectors
> [drm] Connector 0:
> [drm]   LVDS
> [drm]   Encoders:
> [drm]     LCD1: INTERNAL_LVDS
> [drm] Connector 1:
> [drm]   VGA
> [drm]   DDC: 0x60 0x60 0x60 0x60 0x60 0x60 0x60 0x60
> [drm]   Encoders:
> [drm]     CRT1: INTERNAL_DAC1
> [drm] Connector 2:
> [drm]   S-video
> [drm]   Encoders:
> [drm]     TV1: INTERNAL_DAC2
> [drm] fb mappable at 0xE8040000
> [drm] vram apper at 0xE8000000
> [drm] size 1478656
> [drm] fb depth is 8
> [drm]    pitch is 1408
> [drm:drm_calc_timestamping_constants] *ERROR* crtc 10: Can't calculate constants, dotclock = 0!
> Console: switching to colour frame buffer device 175x65
> fb0: radeondrmfb frame buffer device
> drm: registered panic notifier
> [drm] Initialized radeon 2.10.0 20080528 for 0000:01:00.0 on minor 0
-- 
 Microsoft has beaten Volkswagen's world record.  Volkswagen only created 22
 million bugs.
