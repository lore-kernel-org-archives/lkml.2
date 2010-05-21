Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934162Ab0EURFT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 13:05:19 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:65494 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934442Ab0EURFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 13:05:11 -0400
To: Mike Chan <mike@android.com>
Cc: Thomas Renninger <trenn@suse.de>, menage@google.com, balbir@in.ibm.com,
       cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v2 0/3] Enable CPU frequency and power tracking in cpuacct  cgroup
References: <1274380944-20947-1-git-send-email-mike@android.com>
	<201005202301.12259.trenn@suse.de>
	<AANLkTimrJ-F-rBDKnEusN2oViObCCPvZzeIWavkf-tqa@mail.gmail.com>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Fri, 21 May 2010 10:05:08 -0700
In-Reply-To: <AANLkTimrJ-F-rBDKnEusN2oViObCCPvZzeIWavkf-tqa@mail.gmail.com> (Mike Chan's message of "Thu\, 20 May 2010 14\:21\:40 -0700")
Message-ID: <87sk5ljid7.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Chan <mike@android.com> writes:

> On Thu, May 20, 2010 at 2:01 PM, Thomas Renninger <trenn@suse.de> wrote:
>> Hi Mike,
>>
>> On Thursday 20 May 2010 08:42:21 pm Mike Chan wrote:
>>> v2:
>>> Rebased off of Thomas Renninger's patch for cgroups_cpuacct refactoring,
>> thanks.
>> A general comment:
>> I don't know much about the cgroup stuff.
>
> Perhaps Paul Menage or Balbir Singh can look and sign off on the API's?
>
>> I am also not sure how exactly power can be measured on this arch based on
>
> If you know how much time was spent at each frequency executing code,
> you can calculate how much power was consumed if the platform (with
> hooks) provide power numbers (in milliWatts) for the power at
> frequency X.
>
> I did some initial testing on Motorola Droid comparing to a power
> meter and I got within 2% variance.
>
>> frequency accounting (there also were some threads I was not aware of?)
>> A signed-off-by or reviewed-by from someone who is more involved in this omap
>> stuff would probably not that bad.
>>
>
> OMAP was the closest with mainline support I could provide an example
> how to use these hooks.
>
> I'm hoping for some blessing from some people on the linux-omap list
> for that. However can we possibly just stack the first two patches to
> get the API in? This will make it easier to fixup the omap hooks if
> they don't get in.

This looks like a great enhancement to me.

Speaking for OMAP PM... I'd suggest getting the generic stuff upstream
(or into -next) soon and then work out the OMAP specifics after.

Since the OMAP OPP layer is going through some churn (but stabilizing
and will be submitted for 2.6.36), I'd suggest we queue the
OMAP-specific parts of this along with the OPP layer changes.

Kevin
