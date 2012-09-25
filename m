Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552Ab2IYLUc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 07:20:32 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:53040 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754777Ab2IYLU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 07:20:28 -0400
MIME-Version: 1.0
In-Reply-To: <cover.1348568074.git.viresh.kumar@linaro.org>
References: <viresh.kumar@linaro.org>
	<cover.1348568074.git.viresh.kumar@linaro.org>
Date: Tue, 25 Sep 2012 16:50:27 +0530
Message-ID: <CAKohponU76A55RH39pBhmiAsk=GT2yT_G4L5gw6fbpZjODHNPA@mail.gmail.com>
Subject: Re: [PATCH 0/3] Create sched_select_cpu() and use it in workqueues
From: Viresh Kumar <viresh.kumar@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: pjt@google.com, paul.mckenney@linaro.org, tglx@linutronix.de,
        tj@kernel.org, suresh.b.siddha@intel.com, venki@google.com,
        mingo@redhat.com, peterz@infradead.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Arvind.Chauhan@arm.com,
        amit.kucheria@linaro.org, vincent.guittot@linaro.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 September 2012 16:06, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> Test case 2:
> -----------
> I have created a small module, which does following:
> - Create one work for each CPU (using queue_work_on(), so must schedule on that
>   cpu)
> - Above work, will queue "n" works for each cpu with queue_work(). These works
>   are tracked within the module and results are printed at the end.
>
> This gave similar results, with n ranging from 10 to 1000.
>

http://git.linaro.org/gitweb?p=people/vireshk/module.git;a=summary

Source of this module can be found at above repo.

--
viresh
