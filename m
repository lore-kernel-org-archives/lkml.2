Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932139Ab0FAVCU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 17:02:20 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33215 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756190Ab0FAVCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 17:02:18 -0400
MIME-Version: 1.0
In-Reply-To: <87sk5ljid7.fsf@deeprootsystems.com>
References: <1274380944-20947-1-git-send-email-mike@android.com>
	<201005202301.12259.trenn@suse.de>
	<AANLkTimrJ-F-rBDKnEusN2oViObCCPvZzeIWavkf-tqa@mail.gmail.com>
	<87sk5ljid7.fsf@deeprootsystems.com>
Date: Tue, 1 Jun 2010 13:56:33 -0700
Message-ID: <AANLkTilmHyf7XHiYY_U45s7W0yrwBkm2fFW1GfSL3kOT@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] Enable CPU frequency and power tracking in cpuacct 
	cgroup
From: Mike Chan <mike@android.com>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Thomas Renninger <trenn@suse.de>, menage@google.com, balbir@in.ibm.com,
       cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 21, 2010 at 10:05 AM, Kevin Hilman
<khilman@deeprootsystems.com> wrote:
> Mike Chan <mike@android.com> writes:
>
>> On Thu, May 20, 2010 at 2:01 PM, Thomas Renninger <trenn@suse.de> wrote:
>>> Hi Mike,
>>>
>>> On Thursday 20 May 2010 08:42:21 pm Mike Chan wrote:
>>>> v2:
>>>> Rebased off of Thomas Renninger's patch for cgroups_cpuacct refactoring,
>>> thanks.
>>> A general comment:
>>> I don't know much about the cgroup stuff.
>>
>> Perhaps Paul Menage or Balbir Singh can look and sign off on the API's?
>>
>>> I am also not sure how exactly power can be measured on this arch based on
>>
>> If you know how much time was spent at each frequency executing code,
>> you can calculate how much power was consumed if the platform (with
>> hooks) provide power numbers (in milliWatts) for the power at
>> frequency X.
>>
>> I did some initial testing on Motorola Droid comparing to a power
>> meter and I got within 2% variance.
>>
>>> frequency accounting (there also were some threads I was not aware of?)
>>> A signed-off-by or reviewed-by from someone who is more involved in this omap
>>> stuff would probably not that bad.
>>>
>>
>> OMAP was the closest with mainline support I could provide an example
>> how to use these hooks.
>>
>> I'm hoping for some blessing from some people on the linux-omap list
>> for that. However can we possibly just stack the first two patches to
>> get the API in? This will make it easier to fixup the omap hooks if
>> they don't get in.
>
> This looks like a great enhancement to me.
>
> Speaking for OMAP PM... I'd suggest getting the generic stuff upstream
> (or into -next) soon and then work out the OMAP specifics after.
>
> Since the OMAP OPP layer is going through some churn (but stabilizing
> and will be submitted for 2.6.36), I'd suggest we queue the
> OMAP-specific parts of this along with the OPP layer changes.
>

So it looks like there is no objections to this API and I'm OK with
dropping the omap hooks for now until things are settled in 2.6.36. So
are things good with Thomas' re-factoring patch for cpuacct as well as
the first 2 patches?

-- Mike

> Kevin
>
