Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932489Ab0LSUmS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 15:42:18 -0500
Received: from mail-ey0-f171.google.com ([209.85.215.171]:58139 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932471Ab0LSUmR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 15:42:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=TmfeXk7dOqVtxKJ6r2uXLh35gC0weXwYY5PFhDavaSF7J4oqsDeJvcy3OToeZIQGa7
         uTO0eJmCR6LSUkHOqKEUqPbORb1AM4mShbsOL0SLk3odpj5li9DXXZDVq3zxYvhOg5Nq
         1v39mv9wFAAADEIG3t4vYwiUEHO6DKq2GFSSw=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Hui Zhu <teawater@gmail.com>
Subject: Re: [BUG] i915 boot got black screen with 2.6.37-rc5+
Date: Sun, 19 Dec 2010 21:42:11 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc6; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org, keithp@keithp.com, ak@linux.intel.com,
        chris@chris-wilson.co.uk, gregkh@suse.de, stable@kernel.org,
        Andi Kleen <andi@firstfloor.org>
References: <AANLkTimOOmFqxU=r+-RphdfPJ54Qr+6LHU60Grzpnerr@mail.gmail.com>
In-Reply-To: <AANLkTimOOmFqxU=r+-RphdfPJ54Qr+6LHU60Grzpnerr@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201012192142.11656.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=25242
for your bug report, please add your address to the CC list in there, thanks!

On środa, 15 grudnia 2010 o 09:33:29 Hui Zhu wrote:
> The right log with 2.6.37-rc3+:
> Dec 15 16:13:03 teawater-workpc kernel: [ 14.569871] [drm] Initialized
> drm 1.1.0 20060810
> Dec 15 16:13:03 teawater-workpc kernel: [ 14.882768] i915
> 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> Dec 15 16:13:03 teawater-workpc kernel: [ 14.882775] i915
> 0000:00:02.0: setting latency timer to 64
> Dec 15 16:13:03 teawater-workpc kernel: [ 14.894778] mtrr: type
> mismatch for d0000000,10000000 old: write-back new: write-combining
> Dec 15 16:13:03 teawater-workpc kernel: [ 14.894781] [drm] MTRR
> allocation failed. Graphics performance may suffer.
> Dec 15 16:13:03 teawater-workpc kernel: [ 14.895367] i915
> 0000:00:02.0: irq 43 for MSI/MSI-X
> Dec 15 16:13:03 teawater-workpc kernel: [ 14.895610] vgaarb: device
> changed decodes:
> PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
> Dec 15 16:13:03 teawater-workpc kernel: [ 14.895927] [drm] initialized
> overlay support
> Dec 15 16:13:03 teawater-workpc kernel: [ 14.981492] Console:
> switching to colour frame buffer device 210x65
> Dec 15 16:13:03 teawater-workpc kernel: [ 14.986676] fb0: inteldrmfb
> frame buffer device
> Dec 15 16:13:03 teawater-workpc kernel: [ 14.986678] drm: registered
> panic notifier
> Dec 15 16:13:03 teawater-workpc kernel: [ 14.986761] [drm] Initialized
> i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
> 
> The black log with 2.6.37-rc5+:
> Dec 15 16:10:51 teawater-workpc kernel: [ 12.418419] [drm] Initialized
> drm 1.1.0 20060810
> Dec 15 16:10:51 teawater-workpc kernel: [ 12.945240] i915
> 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> Dec 15 16:10:51 teawater-workpc kernel: [ 12.945246] i915
> 0000:00:02.0: setting latency timer to 64
> Dec 15 16:10:51 teawater-workpc kernel: [ 12.957555] mtrr: type
> mismatch for d0000000,10000000 old: write-back new: write-combining
> Dec 15 16:10:51 teawater-workpc kernel: [ 12.957559] [drm] MTRR
> allocation failed. Graphics performance may suffer.
> Dec 15 16:10:51 teawater-workpc kernel: [ 12.958502] i915
> 0000:00:02.0: irq 42 for MSI/MSI-X
> Dec 15 16:10:51 teawater-workpc kernel: [ 12.958806] vgaarb: device
> changed decodes:
> PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
> Dec 15 16:10:51 teawater-workpc kernel: [ 12.959124] [drm] initialized
> overlay support
> Dec 15 16:10:51 teawater-workpc kernel: [ 13.980020] No connectors
> reported connected with modes
> Dec 15 16:10:51 teawater-workpc kernel: [ 13.980025] [drm] Cannot find
> any crtc or sizes - going 1024x768
> Dec 15 16:10:51 teawater-workpc kernel: [ 13.986063] Console:
> switching to colour frame buffer device 128x48
> Dec 15 16:10:51 teawater-workpc kernel: [ 13.988296] fb0: inteldrmfb
> frame buffer device
> Dec 15 16:10:51 teawater-workpc kernel: [ 13.988298] drm: registered
> panic notifier
> Dec 15 16:10:51 teawater-workpc kernel: [ 13.988425] [drm] Initialized
> i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
> 
> Thanks,
> Hui
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
