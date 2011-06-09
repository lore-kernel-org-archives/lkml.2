Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071Ab1FIPvn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 11:51:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55260 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752781Ab1FIPvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 11:51:42 -0400
Date: Thu, 9 Jun 2011 17:51:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, efault@gmx.de,
        Arne Jansen <lists@die-jansens.de>
Subject: Re: [PATCH 3/3] printk: Avoid all wakeups from printk
Message-ID: <20110609155134.GA1681@elte.hu>
References: <20110609130647.937204592@chello.nl>
 <20110609131307.590149293@chello.nl>
 <20110609133228.GB21100@elte.hu>
 <1307626856.3941.80.camel@twins>
 <20110609135542.GD21100@elte.hu>
 <1307628393.3941.87.camel@twins>
 <20110609141959.GF21100@elte.hu>
 <1307629417.3941.89.camel@twins>
 <BANLkTinbBwH-An0-id6YhCSah_p_bfkVtw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTinbBwH-An0-id6YhCSah_p_bfkVtw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, Jun 9, 2011 at 7:23 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > Subject: printk: Avoid all wakeups from printk
> > From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Date: Wed Jun 08 17:29:59 CEST 2011
> 
> Looks good to me.  Is it working? You said that some early version 
> of this caused problems for Ingo?

Yeah, it locked up during lockup in the middle of a printk and i 
bisected it back to the third (most dangerous) commit - will retry 
this version if Peter thinks it's materially different.

Thanks,

	Ingo
