Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193Ab1KKIqm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 03:46:42 -0500
Received: from bitmer.com ([213.157.87.50]:54513 "EHLO bitmer.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754339Ab1KKIqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 03:46:40 -0500
Message-ID: <4EBCE0E6.5020202@bitmer.com>
Date: Fri, 11 Nov 2011 10:46:30 +0200
From: Jarkko Nikula <jarkko.nikula@bitmer.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20111010 Icedove/3.1.15
MIME-Version: 1.0
To: =?ISO-8859-1?Q?P=E9ter_Ujfalusi?= <peter.ujfalusi@ti.com>
CC: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] mfd: twl4030-audio: Fix audio codec breakage
References: <1319013845-2628-1-git-send-email-jarkko.nikula@bitmer.com> <1848643.7W84dlC6t3@barack>
In-Reply-To: <1848643.7W84dlC6t3@barack>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/02/2011 09:41 AM, Péter Ujfalusi wrote:
> On Wednesday 19 October 2011 11:44:05 Jarkko Nikula wrote:
>> Commit 57fe725 ("MFD: twl4030-codec ->  twl4030-audio: Rename the driver")
>> broke the device registration for twl4030 codec if twl6040 is not set.
>>
>> Reason for breakage is that commit didn't update the changed config name for
>> macro twl_has_codec().
>>
>> Signed-off-by: Jarkko Nikula<jarkko.nikula@bitmer.com>
>> Cc: Peter Ujfalusi<peter.ujfalusi@ti.com>
>> ---
>> I don't know is this too late for 3.1 or would it be better to queue for
>> stable when it's out? Anyway breakage happened in 3.1-rc cycle and
>> unfortunately I noticed it only now.
>
> Thanks Jarkko for noticing this. I have overlooked it probably because I'm
> using omap2plus_defconf for most of the time.
>
> The breakage also present in 3.0. Can we queue this patch for stable 3.0.x,
> and 3.1.x?
>
> Acked-by: Peter Ujfalusi<peter.ujfalusi@ti.com>
>
Actually this is already fixed by f09ee04 ("mfd: Fix twl4030 
dependencies for audio codec") which is now in 3.2-rc. Is that commit 
queued for stable too?

-- 
Jarkko
