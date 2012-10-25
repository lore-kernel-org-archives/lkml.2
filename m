Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319Ab2JYFW6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 01:22:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35339 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316Ab2JYFW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 01:22:56 -0400
Message-ID: <5088CC9B.6010009@gmail.com>
Date: Wed, 24 Oct 2012 22:22:35 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Daniel Vetter <daniel@ffwll.ch>
CC: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [drm:i915_hangcheck_hung] *ERROR* Hangcheck timer elapsed...
 GPU hung
References: <2b9aabdc-6f44-40cc-ad0b-4180101570c7@mail.android.htc.com>
In-Reply-To: <2b9aabdc-6f44-40cc-ad0b-4180101570c7@mail.android.htc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
>
> On Tue, Oct 23, 2012 at 10:06:52AM -0700, Justin P. Mattock wrote:
>  > This is happening both with MAINLINE and NEXT.
>  >
>  > basically system is running fine, then under load system becomes
>  > really sluggish and unresponsive. I was able to get dmesg of the
>  > error..:
>  >
>  > [ 7745.007008] ath9k 0000:05:00.0 wlan0: disabling VHT as WMM/QoS is
>  > not supported by the AP
>  > [ 7745.007736] wlan0: associate with 68:7f:74:b8:05:82 (try 1/3)
>  > [ 7745.011456] wlan0: RX AssocResp from 68:7f:74:b8:05:82
>  > (capab=0x411 status=0 aid=5)
>  > [ 7745.011529] wlan0: associated
>  > [ 8120.812482] [drm:i915_hangcheck_hung] *ERROR* Hangcheck timer
>  > elapsed... GPU hung
>  > [ 8120.812642] [drm] capturing error event; look for more
>  > information in /debug/dri/0/i915_error_state
>  > [ 8122.328682] [drm:i915_hangcheck_hung] *ERROR* Hangcheck timer
>  > elapsed... GPU hung
>  > [ 8122.328845] [drm:i915_reset] *ERROR* GPU hanging too fast,
>  > declaring wedged!
>  > [ 8122.328850] [drm:i915_reset] *ERROR* Failed to reset chip.
>  >
>  > full log is here: http://fpaste.org/7xH8/
>  >
>  > as for good kernels from what I remember 3.6.0-rc1. I can try a
>  > bisect on this once I get the time. or if anybody has a patch I can
>  > test.
>
> Can you please rehand your machine, and then grab the i915_error_state
> from debugfs? That contains the gpu hang dump we need to diagnose things.
>
> And the bisect would obviously be awesome.
>
> Thanks, Daniel
> --
> Daniel Vetter
> Software Engineer, Intel Corporation
> +41 (0) 79 365 57 48 - http://blog.ffwll.ch

took a bit to trigger, but finally fired off.

here is a link to the file..: intel_error_decode
http://www.filefactory.com/file/22bypyjhs4mx

the file was to large to send to the list.. let me know if you need more 
info with this.
also if anybody has any ideas to trigger this would be appreciated so 
the bisect can be more precise. right now dont even think its worth it, 
due to not being able to trigger the crash causing the bisect to go 
astray and pointing to a wrong commit(which has happened in the past) 
but then again you never know.

Justin P. Mattock
