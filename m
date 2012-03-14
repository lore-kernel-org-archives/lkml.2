Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610Ab2CNL3e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 07:29:34 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50936 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756055Ab2CNL3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 07:29:30 -0400
Message-ID: <4F608116.80508@linaro.org>
Date: Wed, 14 Mar 2012 12:29:26 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Robert Lee <rob.lee@linaro.org>, Jean Pihet <j-pihet@ti.com>,
        Kevin Hilman <khilman@ti.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: next-20120313 cpuidle freezes when booting
References: <alpine.LSU.2.00.1203131454500.1335@eggly.anvils>
In-Reply-To: <alpine.LSU.2.00.1203131454500.1335@eggly.anvils>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2012 11:29 PM, Hugh Dickins wrote:
> Hi Stephen,
>
> Yesterday's 3.3.0-rc7-next-20120313 gives me unpredictable freezes
> on x86_64, on a ThinkPad T420s - I've not dared it on more machines.
>
> Usually when booting up (sometimes just after Freeing unused kernel
> memory, sometimes random places elsewhere), but occasionally it manages
> to get as far as X; doesn't usually manage to complete suspend+resume.
>
> 3.3.0-rc6-nex-20120309 behaved similarly; the last I tried before
> that was 3.3.0-rc5-next20120227, which was okay.
>
> Bisection led me to "cpuidle: Add common time keeping and irq enabling",
> (from the cpuidle-cons tree I think), and reverting that has so far
> given me a working system (it's a success if I complete this mail).
>
> Below is the patch I've used to revert it (for other people having
> problems with recent linux-next to try); but it's not quite correct,
> because you did a merge on conflicting trees there, and I didn't spend
> time to unravel all that, just get a working x86 system - since I've
> left out some of your merge (in arch/arm/kernel/Makefile and arch/arm/
> mach-at91/cpuidle.c), this reversion probably breaks arm as is.

Hi Hugh,

is it possible you give the cpuidle driver your host is using ?

Thanks
   -- Daniel

-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

