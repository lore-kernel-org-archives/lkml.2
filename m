Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757951Ab2IYRrq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 13:47:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61210 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757873Ab2IYRrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 13:47:45 -0400
Date: Tue, 25 Sep 2012 10:47:40 -0700
From: Tejun Heo <tj@kernel.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linux-kernel@vger.kernel.org, pjt@google.com, paul.mckenney@linaro.org,
        tglx@linutronix.de, suresh.b.siddha@intel.com, venki@google.com,
        mingo@redhat.com, peterz@infradead.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Arvind.Chauhan@arm.com,
        amit.kucheria@linaro.org, vincent.guittot@linaro.org,
        linaro-dev@lists.linaro.org, patches@linaro.org
Subject: Re: [PATCH 2/3] workqueue: create __flush_delayed_work to avoid
 duplicating code
Message-ID: <20120925174740.GA16296@google.com>
References: <cover.1348568074.git.viresh.kumar@linaro.org>
 <e2ec86881d767207abbcdc9e49d2aa389e1689b1.1348568074.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2ec86881d767207abbcdc9e49d2aa389e1689b1.1348568074.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 04:06:07PM +0530, Viresh Kumar wrote:
> flush_delayed_work() and flush_delayed_work_sync() had major portion of code
> similar. This patch introduces another routine __flush_delayed_work() which
> contains the common part to avoid code duplication.

This part has seen a lot of update in pending wq/for-3.7 branch.
Please rebase on top of that.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-3.7

Thanks.

-- 
tejun
