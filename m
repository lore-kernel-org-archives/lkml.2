Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758904Ab0EMMeE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 08:34:04 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:40653 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751866Ab0EMMeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 08:34:01 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Airlie <airlied@linux.ie>
Subject: Re: 2.6.33.2 kmalloc-8 slab leaks ~512 objects per second
References: <201005121121.49135.tvrtko.ursulin@sophos.com>
	<g2i84144f021005120600wa8eb0409k13f67f49c519509@mail.gmail.com>
	<201005121404.49720.tvrtko.ursulin@sophos.com>
Date: Thu, 13 May 2010 13:29:49 +0100
In-Reply-To: <201005121404.49720.tvrtko.ursulin@sophos.com> (Tvrtko Ursulin's
	message of "Wed, 12 May 2010 14:04:48 +0100")
Message-ID: <tnxiq6sm1c2.fsf@e102109-lin.cambridge.arm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 13 May 2010 12:29:58.0506 (UTC) FILETIME=[00281CA0:01CAF298]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tvrtko Ursulin <tvrtko.ursulin@sophos.com> wrote:
> On Wednesday 12 May 2010 14:00:51 Pekka Enberg wrote:
>> [snip]
>>
>> You might want to try out the built-in kernel memory leak detector.
>> See Documentation/kmemleak.txt for details how to enable it and use
>> it.
>
> Thanks for the suggestion, I will have to try it out once but not this time :)
> because 2.6.34-rc7 seems to be fine, or in other words not leaking.

You could just enable CONFIG_DEBUG_KMEMLEAK on 2.6.33, mount the debugfs
and do a 'cat /sys/kernel/debug/kmemleak' after a half-hour or so.

-- 
Catalin
