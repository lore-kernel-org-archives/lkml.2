Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903Ab1AVLTJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 06:19:09 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65216 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721Ab1AVLTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 06:19:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=n01cdYPbci4pGFoHaOiWZpv0ywIXDKqzQ7duMlvDIEdHj6HDBu5Olgiy8p9oRJB5ur
         yy6bfEzcxws4F7F+9UZ5o3KHVJhr5+fEXlYTCTVwILjfVPMkFwsyeC5hn8n1m+yYSBKp
         PwilngKu29K6wJfPuBs79DK+Y4z/SIe0CZSvI=
From: Chris Clayton <chris2553@googlemail.com>
Reply-To: chris2553@googlemail.com
To: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH] drm/i915: Increase the amount of defense before computing vblank timestamps
Date: Sat, 22 Jan 2011 11:18:53 +0000
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
References: <:201101220935.03623.chris2553@googlemail.com> <1295691099-14276-1-git-send-email-chris@chris-wilson.co.uk>
In-Reply-To: <1295691099-14276-1-git-send-email-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201101221118.53141.chris2553@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 22 January 2011, Chris Wilson wrote:
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> ---
>
> Chris, does this help?
>

Sorry Chris, X still doesn't start with this patch applied. The symptoms are 
slightly different in that the monitor doesn't go into power saving mode, but 
the screen is still black and I have to recycle the power to get the machine 
back.
The messages in the log file has changed though.We now have:

Jan 22 11:03:47 upstairs kernel: r8169 0000:02:00.0: eth0: link up
Jan 22 11:03:57 upstairs kernel: [drm] Initialized drm 1.1.0 20060810
Jan 22 11:03:58 upstairs kernel: pci 0000:00:02.0: PCI INT A -> GSI 16 (level, 
low) -> IRQ 16
Jan 22 11:03:58 upstairs kernel: pci 0000:00:02.0: setting latency timer to 64
Jan 22 11:03:58 upstairs kernel: ioremap error for 0xbdce0000-0xbdce3000, 
requested 0x10, got 0x0
Jan 22 11:03:58 upstairs kernel: [drm] Supports vblank timestamp caching Rev 1 
(10.10.2010).
Jan 22 11:03:58 upstairs kernel: [drm] Driver supports precise vblank timestamp 
query.
Jan 22 11:03:58 upstairs kernel: [drm] Initialized i915 1.6.0 20080730 for 
0000:00:02.0 on minor 0
Jan 22 11:04:18 upstairs kernel: [drm:i915_get_vblank_timestamp] *ERROR* Invalid 
crtc 0
Jan 22 11:04:18 upstairs last message repeated 8 times
Jan 22 11:04:18 upstairs kernel: [drm:i915_do_wait_request] *ERROR* something 
(likely vbetool) disabled interrupts, re-enabling
Jan 22 11:04:21 upstairs kernel: [drm:i915_get_vblank_timestamp] *ERROR* Invalid 
crtc 0
Jan 22 11:04:29 upstairs last message repeated 35 times
Jan 22 11:04:29 upstairs kernel: [drm:i915_do_wait_request] *ERROR* something 
(likely vbetool) disabled interrupts, re-enabling
Jan 22 11:04:32 upstairs kernel: [drm:i915_get_vblank_timestamp] *ERROR* Invalid 
crtc 0
Jan 22 11:05:00 upstairs last message repeated 98 times
Jan 22 11:05:00 upstairs kernel: [drm:i915_do_wait_request] *ERROR* something 
(likely vbetool) disabled interrupts, re-enabling
Jan 22 11:05:03 upstairs kernel: [drm:i915_get_vblank_timestamp] *ERROR* Invalid 
crtc 0
Jan 22 11:05:06 upstairs last message repeated 17 times
Jan 22 11:05:06 upstairs kernel: [drm:i915_do_wait_request] *ERROR* something 
(likely vbetool) disabled interrupts, re-enabling

> If you can convert the address to a line number that would pinpoint the

Not done that before and nothing jumped out of my search on google, so how do I 
go about getting the line number for you, please?

> NULL pointer exactly. Though judging by the address and position of the
> dereference a NULL crtc looks most likely.

<snip>


-- 
The more I see, the more I know. The more I know, the less I understand. 
Changing Man - Paul Weller
