Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743Ab2FGUgP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 16:36:15 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50525 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754296Ab2FGUgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 16:36:13 -0400
MIME-Version: 1.0
In-Reply-To: <1339101083.28766.80.camel@sbsiddha-desk.sc.intel.com>
References: <20120509093001.GD8585@gmail.com>
	<1336589196-14498-1-git-send-email-suresh.b.siddha@intel.com>
	<1336589196-14498-2-git-send-email-suresh.b.siddha@intel.com>
	<1336593505.4634.11.camel@sbsiddha-desk.sc.intel.com>
	<20120510075031.GC28395@gmail.com>
	<1339025388.28766.70.camel@sbsiddha-desk.sc.intel.com>
	<CAE9FiQXh82++LRJnFbYXAVQmCPM00M8HO0KQ523WYD+rZKvt2w@mail.gmail.com>
	<1339101083.28766.80.camel@sbsiddha-desk.sc.intel.com>
Date: Thu, 7 Jun 2012 13:36:13 -0700
X-Google-Sender-Auth: aoo1L2k7gZT1pTVbUFHsctXHt-k
Message-ID: <CAE9FiQX=UGETwk+j1YQzGSJQsvuTWBN1LzL_BbF2r5qS-EFG7Q@mail.gmail.com>
Subject: Re: [patch] irq: use config_enabled(SMP) checks to cleanup
 irq_set_affinity() for UP
From: Yinghai Lu <yinghai@kernel.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        joerg.roedel@amd.com, paul.gortmaker@windriver.com,
        Sam Ravnborg <sam@ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 7, 2012 at 1:31 PM, Suresh Siddha <suresh.b.siddha@intel.com> wrote:
>>
>> can you just use
>> if (nr_cpu_ids > 1)
>> checking instead
>> if config_enabled(CONFIG_SMP)
>
> Idea is to not have any extra runtime checks if CONFIG_SMP is enabled
> and which is when all the smp affinity routines are used/invoked.

then could use
if (NR_CPUS > 1)

Thanks

Yinghai
