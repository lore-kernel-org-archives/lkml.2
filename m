Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760812Ab2C3Mxq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 08:53:46 -0400
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:44484 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760777Ab2C3Mxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 08:53:41 -0400
Message-ID: <4F75ACCA.4090009@ti.com>
Date: Fri, 30 Mar 2012 18:23:30 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120310 Thunderbird/11.0
MIME-Version: 1.0
To: Colin Cross <ccross@android.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@lists.linux-foundation.org, Kevin Hilman <khilman@ti.com>,
        Len Brown <len.brown@intel.com>, Trinabh Gupta <g.trinabh@gmail.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Rob Lee <rob.lee@linaro.org>
Subject: Re: [PATCHv2 0/5] coupled cpuidle state support
References: <1331749794-8056-1-git-send-email-ccross@android.com> <CAMbhsRQAw2+as13NVvWkh7ojyRs+jNpFist2gmiiEY52U=o84A@mail.gmail.com>
In-Reply-To: <CAMbhsRQAw2+as13NVvWkh7ojyRs+jNpFist2gmiiEY52U=o84A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Colin,

On Friday 16 March 2012 05:07 AM, Colin Cross wrote:
> On Wed, Mar 14, 2012 at 11:29 AM, Colin Cross <ccross@android.com> wrote:

[...]

>>
>> v2:
>>   * removed the coupled lock, replacing it with atomic counters
>>   * added a check for outstanding pokes before beginning the
>>     final transition to avoid extra wakeups
>>   * made the cpuidle_coupled struct completely private
>>   * fixed kerneldoc comment formatting
>>   * added a patch with a helper function for resynchronizing
>>     cpus after aborting idle
>>   * added a patch (not for merging) to add trace events for
>>     verification and performance testing
> 
> I forgot to mention, this patch series is on v3.3-rc7, and will
> conflict with the cpuidle timekeeping patches.  If those go in first
> (which is likely), I will rework this series on top of it.  I left it
> on v3.3-rc7 now to make testing easier.

I have re-based your series against Len Browns
next branch [1] which has time keeping and other cpuidle patches.
Have also folded the CPU hotplug fix which I posted in the
original coupled idle patch.

If you want, the updated branch can be pulled from:

git://gitorious.org/omap-sw-develoment/linux-omap-dev.git
for_3.5/coupled_cpuidle-rebase

Regards
Santosh

[1] Power Management
git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux.git
