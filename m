Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758185Ab2DIXfh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 19:35:37 -0400
Received: from na3sys009aog132.obsmtp.com ([74.125.149.250]:43519 "EHLO
	psmtp.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753491Ab2DIXff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 19:35:35 -0400
From: Kevin Hilman <khilman@ti.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Colin Cross <ccross@android.com>, Len Brown <len.brown@intel.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Amit Kucheria <amit.kucheria@linaro.org>,
        linux-pm@lists.linux-foundation.org,
        Arjan van de Ven <arjan@linux.intel.com>, Rob Lee <rob.lee@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [linux-pm] [PATCHv2 0/5] coupled cpuidle state support
Organization: Texas Instruments, Inc.
References: <1331749794-8056-1-git-send-email-ccross@android.com>
	<CAMbhsRQAw2+as13NVvWkh7ojyRs+jNpFist2gmiiEY52U=o84A@mail.gmail.com>
	<4F75ACCA.4090009@ti.com> <4F828BAB.5010302@ti.com>
Date: Mon, 09 Apr 2012 16:35:40 -0700
In-Reply-To: <4F828BAB.5010302@ti.com> (Santosh Shilimkar's message of "Mon,
	09 Apr 2012 12:41:39 +0530")
Message-ID: <87mx6k7a2b.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Santosh Shilimkar <santosh.shilimkar@ti.com> writes:

> On Friday 30 March 2012 06:23 PM, Santosh Shilimkar wrote:
>> Colin,
>> 
>> On Friday 16 March 2012 05:07 AM, Colin Cross wrote:
>>> On Wed, Mar 14, 2012 at 11:29 AM, Colin Cross <ccross@android.com> wrote:
>> 
>> [...]
>> 
>>>>
>>>> v2:
>>>>   * removed the coupled lock, replacing it with atomic counters
>>>>   * added a check for outstanding pokes before beginning the
>>>>     final transition to avoid extra wakeups
>>>>   * made the cpuidle_coupled struct completely private
>>>>   * fixed kerneldoc comment formatting
>>>>   * added a patch with a helper function for resynchronizing
>>>>     cpus after aborting idle
>>>>   * added a patch (not for merging) to add trace events for
>>>>     verification and performance testing
>>>
>>> I forgot to mention, this patch series is on v3.3-rc7, and will
>>> conflict with the cpuidle timekeeping patches.  If those go in first
>>> (which is likely), I will rework this series on top of it.  I left it
>>> on v3.3-rc7 now to make testing easier.
>> 
>> I have re-based your series against Len Browns
>> next branch [1] which has time keeping and other cpuidle patches.
>> Have also folded the CPU hotplug fix which I posted in the
>> original coupled idle patch.
>> 
> As you know, we have been playing around this series for OMAP
> for last few weeks. This version series seems to work as intended
> and found it pretty stable in my testing. Apart from the cpu
> hotplug fix and the trace event comment, series looks fine
> to me.
>
> FWIW,
> Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Tested-by: Santosh Shilimkar <santosh.shilimkar@ti.com>	

Also

Reviewed-by: Kevin Hilman <khilman@ti.com>
Tested-by: Kevin Hilman <khilman@ti.com>

as I've been working with Santosh on getting this stabilized on OMAP and
we are very keen to see this functionality merged.

Thanks,

Kevin

