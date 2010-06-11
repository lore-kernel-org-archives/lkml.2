Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760163Ab0FKKiN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 06:38:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36090 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760106Ab0FKKiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 06:38:12 -0400
Date: Fri, 11 Jun 2010 12:38:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Panic on boot on today's tip/master
Message-ID: <20100611103803.GB14586@elte.hu>
References: <20100610112839.GK5878@linux.vnet.ibm.com>
 <4C11CA1C.3010102@zytor.com>
 <20100611102654.GB9562@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100611102654.GB9562@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.5
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.3098]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Srikar Dronamraju <srikar@linux.vnet.ibm.com> wrote:

> > Any way you could run a bisect between these commits?
> 
> Now sure I got to those commit id's. Those don't seem to be present in the 
> git log when I grep today. And I am able to boot the system with today's tip 
> tree.
> 
> I am extremely sorry for the noise.

Not noise at all! Yesternight i triggered a different boot crash myself and 
bisected it down to:

f88731e3068f9d1392ba71cc9f50f035d26a0d4f x86, alternatives: Use 16-bit numbers for cpufeature index

... which was included in your git log as well.

So i am quite sure that commit has caused your boot crash as well!

Thanks,

	Ingo
