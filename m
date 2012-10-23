Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356Ab2JWRjr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 13:39:47 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:61979 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754948Ab2JWRjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 13:39:46 -0400
Date: Tue, 23 Oct 2012 19:40:47 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [drm:i915_hangcheck_hung] *ERROR* Hangcheck timer elapsed... GPU
 hung
Message-ID: <20121023174047.GT24005@phenom.ffwll.local>
Mail-Followup-To: "Justin P. Mattock" <justinmattock@gmail.com>,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <5086CEAC.2000804@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5086CEAC.2000804@gmail.com>
X-Operating-System: Linux phenom 3.6.0-rc7+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 10:06:52AM -0700, Justin P. Mattock wrote:
> This is happening both with MAINLINE and NEXT.
> 
> basically system is running fine, then under load system becomes
> really sluggish and unresponsive. I was able to get dmesg of the
> error..:
> 
> [ 7745.007008] ath9k 0000:05:00.0 wlan0: disabling VHT as WMM/QoS is
> not supported by the AP
> [ 7745.007736] wlan0: associate with 68:7f:74:b8:05:82 (try 1/3)
> [ 7745.011456] wlan0: RX AssocResp from 68:7f:74:b8:05:82
> (capab=0x411 status=0 aid=5)
> [ 7745.011529] wlan0: associated
> [ 8120.812482] [drm:i915_hangcheck_hung] *ERROR* Hangcheck timer
> elapsed... GPU hung
> [ 8120.812642] [drm] capturing error event; look for more
> information in /debug/dri/0/i915_error_state
> [ 8122.328682] [drm:i915_hangcheck_hung] *ERROR* Hangcheck timer
> elapsed... GPU hung
> [ 8122.328845] [drm:i915_reset] *ERROR* GPU hanging too fast,
> declaring wedged!
> [ 8122.328850] [drm:i915_reset] *ERROR* Failed to reset chip.
> 
> full log is here: http://fpaste.org/7xH8/
> 
> as for good kernels from what I remember 3.6.0-rc1. I can try a
> bisect on this once I get the time. or if anybody has a patch I can
> test.

Can you please rehand your machine, and then grab the i915_error_state
from debugfs? That contains the gpu hang dump we need to diagnose things.

And the bisect would obviously be awesome.

Thanks, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
