Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376Ab0ETVVo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 17:21:44 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38226 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186Ab0ETVVm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 17:21:42 -0400
MIME-Version: 1.0
In-Reply-To: <201005202301.12259.trenn@suse.de>
References: <1274380944-20947-1-git-send-email-mike@android.com>
	 <201005202301.12259.trenn@suse.de>
Date: Thu, 20 May 2010 14:21:40 -0700
Message-ID: <AANLkTimrJ-F-rBDKnEusN2oViObCCPvZzeIWavkf-tqa@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] Enable CPU frequency and power tracking in cpuacct 
	cgroup
From: Mike Chan <mike@android.com>
To: Thomas Renninger <trenn@suse.de>
Cc: menage@google.com, balbir@in.ibm.com, cpufreq@vger.kernel.org,
       linux-kernel@vger.kernel.org, khilman@deeprootsystems.com,
       linux-omap@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 20, 2010 at 2:01 PM, Thomas Renninger <trenn@suse.de> wrote:
> Hi Mike,
>
> On Thursday 20 May 2010 08:42:21 pm Mike Chan wrote:
>> v2:
>> Rebased off of Thomas Renninger's patch for cgroups_cpuacct refactoring,
> thanks.
> A general comment:
> I don't know much about the cgroup stuff.

Perhaps Paul Menage or Balbir Singh can look and sign off on the API's?

> I am also not sure how exactly power can be measured on this arch based on

If you know how much time was spent at each frequency executing code,
you can calculate how much power was consumed if the platform (with
hooks) provide power numbers (in milliWatts) for the power at
frequency X.

I did some initial testing on Motorola Droid comparing to a power
meter and I got within 2% variance.

> frequency accounting (there also were some threads I was not aware of?)
> A signed-off-by or reviewed-by from someone who is more involved in this omap
> stuff would probably not that bad.
>

OMAP was the closest with mainline support I could provide an example
how to use these hooks.

I'm hoping for some blessing from some people on the linux-omap list
for that. However can we possibly just stack the first two patches to
get the API in? This will make it easier to fixup the omap hooks if
they don't get in.

-- Mike

> Still I Iike this interface and I could imagine others hook into it as well,
> for whatever has to be cpu cgroup accounted.
>
> My two cents...,
>
>     Thomas
> --
> To unsubscribe from this list: send the line "unsubscribe cpufreq" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
