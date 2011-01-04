Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751342Ab1ADK6w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 05:58:52 -0500
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:38362 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750781Ab1ADK6v convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 05:58:51 -0500
MIME-Version: 1.0
In-Reply-To: <20110104104203.GB2447@elte.hu>
References: <1294136263-24020-1-git-send-email-j-pihet@ti.com>
	<1294136263-24020-3-git-send-email-j-pihet@ti.com>
	<20110104104203.GB2447@elte.hu>
Date: Tue, 4 Jan 2011 11:58:40 +0100
Message-ID: <AANLkTikjfH1q_74ON8EO=hY+aVuGAu4b22QuvJo-x-ow@mail.gmail.com>
Subject: Re: [PATCH 2/3] perf: add OMAP support for the new power events
From: "Pihet-XID, Jean" <j-pihet@ti.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: jean.pihet@newoldbits.com, linux-kernel@vger.kernel.org, trenn@suse.de,
        linux-omap@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>,
        linux-perf-users@vger.kernel.org, rjw@sisk.pl
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 4, 2011 at 11:42 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * jean.pihet@newoldbits.com <jean.pihet@newoldbits.com> wrote:
>
>> From: Jean Pihet <j-pihet@ti.com>
>>
>> The patch adds the new power management trace points for
>> the OMAP architecture.
>>
>> The trace points are for:
>> - default idle handler. Since the cpuidle framework is
>>   instrumented in the generic way there is no need to
>>   add trace points in the OMAP specific cpuidle handler;
>> - cpufreq (DVFS),
>> - clocks changes (enable, disable, set_rate),
>> - change of power domains next power states.
>>
>> Signed-off-by: Jean Pihet <j-pihet@ti.com>
>> ---
>>  arch/arm/mach-omap2/pm34xx.c      |    7 +++++++
>>  arch/arm/mach-omap2/powerdomain.c |    3 +++
>>  arch/arm/plat-omap/clock.c        |   13 ++++++++++---
>>  3 files changed, 20 insertions(+), 3 deletions(-)
>
> I suspect the gents and mailing lists listed by:
>
>  scripts/get_maintainer.pl -f arch/arm/plat-omap/clock.c
>  scripts/get_maintainer.pl -f arch/arm/mach-omap2/pm34xx.c
>
> Would want to be Cc:-ed as well.
Sorry about that. The patches 1 & 2 have been re-sent with additional Cc's.

> That will also get the right Acked-by's. (if you
> want these commits to go upstream via the perf tree)
Yes the idea is to get those upstream via the tip tree, since it now
contains the perf API clean-up patches from Thomas.

>
> Thanks,
>
>        Ingo
>

Thanks,
Jean
