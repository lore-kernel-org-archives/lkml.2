Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185Ab0KYNkI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 08:40:08 -0500
Received: from mailhost-y4-m4.nerim.net ([78.40.49.241]:24196 "EHLO
	smtp-delay2.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752824Ab0KYNkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 08:40:06 -0500
X-Greylist: delayed 516 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Nov 2010 08:40:06 EST
Date: Thu, 25 Nov 2010 14:31:06 +0100
From: Damien Wyart <damien.wyart@free.fr>
To: Peter Zijlstra <peterz@infradead.org>
Cc: tmhikaru@gmail.com, Venkatesh Pallipadi <venki@google.com>,
        Chase Douglas <chase.douglas@canonical.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: High CPU load when machine is idle (related to PROBLEM:
 Unusually high load average when idle in 2.6.35, 2.6.35.1 and later)
Message-ID: <20101125133106.GA12914@brouette>
References: <1287788622-25860-1-git-send-email-venki@google.com>
 <1288001573.15336.52.camel@twins>
 <1288097074.15336.211.camel@twins>
 <1288101958.15336.284.camel@twins>
 <1288381343.1988.12.camel@laptop>
 <20101109185516.GQ8332@bombadil.infradead.org>
 <1289329348.2191.69.camel@laptop>
 <20101110034507.GV8332@bombadil.infradead.org>
 <1289390424.2191.98.camel@laptop>
 <20101114051406.GA2050@roll>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101114051406.GA2050@roll>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

Do you have a plan about solving this problem in the coming weeks or
will it still be present in 2.6.37 final? I am not implying any critic
in any way, just want to know a status because compared to other bugs
discussed in lkml, this one has seen very little technical proposals
towards a resolution (except your attempts). People who signed off the
discussed commit did not make any technical analysis about the bug
reported and this gives a strange feeling. Earth will not stop rotating
if it is not solved, but I still this it is quite important and affects
many users.

> [74f5187ac873042f502227701ed1727e7c5fbfa9] sched: Cure load average vs> NO_HZ woes

> We've gone through two kernel releases with this commit, and I think
> I'm understandably curious why it's not been reverted if it's causing
> problems with no solution in sight.

Even with this commit reverted, the load is incorrect in NO_HZ mode, so
revert only is not enough.

-- 
Damien Wyart
