Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249Ab2LNGfm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 01:35:42 -0500
Received: from mga14.intel.com ([143.182.124.37]:29268 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218Ab2LNGfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 01:35:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,279,1355126400"; 
   d="scan'208";a="231433078"
Message-ID: <50CAC905.9070100@intel.com>
Date: Fri, 14 Dec 2012 14:36:53 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Mike Galbraith <bitbucket@online.de>
CC: Vincent Guittot <vincent.guittot@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-dev@lists.linaro.org,
        peterz@infradead.org, mingo@kernel.org, linux@arm.linux.org.uk,
        pjt@google.com, santosh.shilimkar@ti.com, Morten.Rasmussen@arm.com,
        chander.kashyap@linaro.org, cmetcalf@tilera.com, tony.luck@intel.com,
        preeti@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, len.brown@intel.com, arjan@linux.intel.com,
        amit.kucheria@linaro.org, viresh.kumar@linaro.org
Subject: Re: [RFC PATCH v2 3/6] sched: pack small tasks
References: <1355319092-30980-1-git-send-email-vincent.guittot@linaro.org>  <1355319092-30980-4-git-send-email-vincent.guittot@linaro.org>  <50C93AC1.1060202@intel.com>  <CAKfTPtB9iz1ePsS+juQVRhuWREYB1duGWRJT7ya8XBXPhC-mkw@mail.gmail.com>  <50C9E552.1010600@intel.com> <1355460356.5777.12.camel@marge.simpson.net>
In-Reply-To: <1355460356.5777.12.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2012 12:45 PM, Mike Galbraith wrote:
>> > Do you have further ideas for buddy cpu on such example?
>>> > > 
>>> > > Which kind of sched_domain configuration have you for such system ?
>>> > > and how many sched_domain level have you ?
>> > 
>> > it is general X86 domain configuration. with 4 levels,
>> > sibling/core/cpu/numa.
> CPU is a bug that slipped into domain degeneration.  You should have
> SIBLING/MC/NUMA (chasing that down is on todo).

Maybe.
the CPU/NUMA is different on domain flags, CPU has SD_PREFER_SIBLING.
