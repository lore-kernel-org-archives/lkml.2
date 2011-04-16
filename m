Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200Ab1DPJ0n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 05:26:43 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:53161 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936Ab1DPJ0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 05:26:35 -0400
From: Martin <marogge@onlinehome.de>
To: linux-kernel@vger.kernel.org, wzab@ise.pw.edu.pl, chris@chris-wilson.co.uk
Subject: Re: i915 drm GPU hung errors with kernel 2.6.38.2 on  82865G chipset
Date: Sat, 16 Apr 2011 11:26:28 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38.2-ck3; KDE/4.5.5; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104161126.28209.marogge@onlinehome.de>
X-Provags-ID: V02:K0:OlSjzD+Rx1uSPd0nKsgmDmnTYnFgIWzISucONqjwtMc
 ftpbzxEW++0sqYx3Qln5L5AhmdKFFx8HGU/Rd0XT9VabWR9YZ0
 jx8ysKdwtlL0CmV1ChqMIlfQfuPYGhq5zMTohrO5KrSsvxN7PD
 GL2KQifxL150wT6j9CYznnqJ75Drnj2A49cq0hG4a9Kc3SxEpj
 sgEExzFb+oGc8RzhX0bPQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wzab wrote:

> Today I have experienced two "GPU hungs" on machine with 82865G chipset
> working with 2.6.38.2 kernel
> In the /var/log/syslog I have found the following errors:
> 
> [...]
> 

Hi, just for info, I seemingly had the same error occurring yesterday, but I 
also failed to retrieve information from the debugfs. Also on 2.6.38.2, 
chipset being H55 Express. Seems to happen after a long uptime. I will be more 
careful to retrieve debug information next time.

Another sort-of-regression I noticed since moving to 2.6.38 is the 30 second 
waiting period when resuming. However, I have no idea what driver might be the 
cause.

Martin

---- from syslog ----

Apr 15 19:16:28 arnold kernel: [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck 
timer elapsed... GPU hung
Apr 15 19:16:28 arnold kernel: [drm:i915_do_wait_request] *ERROR* 
i915_do_wait_request returns -11 (awaiting 50400651 at 50400598, next 
50400652)

Apr 15 19:16:30 arnold kernel: [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck 
timer elapsed... GPU hung
Apr 15 19:16:30 arnold kernel: [drm:init_ring_common] *ERROR* failed to set 
render ring head to zero ctl 00000000 head 87c0f714 tail 00000000 start 
00001000
Apr 15 19:16:30 arnold kernel: [drm:init_ring_common] *ERROR* render ring 
initialization failed ctl 0001f003 head 87c0f714 tail 00000000 start 00001000
Apr 15 19:16:58 arnold kernel: [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck 
timer elapsed... GPU hung
Apr 15 19:16:58 arnold kernel: [drm:init_ring_common] *ERROR* failed to set 
render ring head to zero ctl 00000000 head 87c0f714 tail 00000000 start 
00001000
Apr 15 19:16:58 arnold kernel: [drm:init_ring_common] *ERROR* render ring 
initialization failed ctl 0001f003 head 87c0f714 tail 00000000 start 00001000
