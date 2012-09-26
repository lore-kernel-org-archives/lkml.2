Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513Ab2IZEWR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 00:22:17 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:40316 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab2IZEWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 00:22:15 -0400
MIME-Version: 1.0
In-Reply-To: <20120925174740.GA16296@google.com>
References: <cover.1348568074.git.viresh.kumar@linaro.org>
	<e2ec86881d767207abbcdc9e49d2aa389e1689b1.1348568074.git.viresh.kumar@linaro.org>
	<20120925174740.GA16296@google.com>
Date: Wed, 26 Sep 2012 09:52:14 +0530
Message-ID: <CAKohponXJPAregg6qBvr+12cbhyvkdy=EAFHjTp0JfzRxM=VkQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] workqueue: create __flush_delayed_work to avoid
 duplicating code
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, pjt@google.com, paul.mckenney@linaro.org,
        tglx@linutronix.de, suresh.b.siddha@intel.com, venki@google.com,
        mingo@redhat.com, peterz@infradead.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Arvind.Chauhan@arm.com,
        amit.kucheria@linaro.org, vincent.guittot@linaro.org,
        linaro-dev@lists.linaro.org, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 September 2012 23:17, Tejun Heo <tj@kernel.org> wrote:
> On Tue, Sep 25, 2012 at 04:06:07PM +0530, Viresh Kumar wrote:
>> flush_delayed_work() and flush_delayed_work_sync() had major portion of code
>> similar. This patch introduces another routine __flush_delayed_work() which
>> contains the common part to avoid code duplication.
>
> This part has seen a lot of update in pending wq/for-3.7 branch.
> Please rebase on top of that.
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-3.7

So, this patch is not required anymore. As they are already merged :)
