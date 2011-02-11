Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645Ab1BKOHM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 09:07:12 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50005 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756439Ab1BKOHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 09:07:10 -0500
Date: Fri, 11 Feb 2011 15:07:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PULL] cpumask offstack finalization
Message-ID: <20110211140700.GA16925@elte.hu>
References: <201102091608.59448.rusty@rustcorp.com.au>
 <20110210124416.GE26094@elte.hu>
 <201102110802.17453.rusty@rustcorp.com.au>
 <alpine.LFD.2.00.1102102310491.31804@localhost6.localdomain6>
 <AANLkTinMsD664FiDZy2ZtVo2jtH0x7m30EyMay9REmwj@mail.gmail.com>
 <20110210235956.GA3231@elte.hu>
 <AANLkTikbYZHQoGUOO6NtVORXrUzrqNV3GJVzm0NHeUUy@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikbYZHQoGUOO6NtVORXrUzrqNV3GJVzm0NHeUUy@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexey Dobriyan <adobriyan@gmail.com> wrote:

> On Fri, Feb 11, 2011 at 1:59 AM, Ingo Molnar <mingo@elte.hu> wrote:
> > Hey, if that's what it takes to get __deprecated removed i'll bring it up tomorrow!!
> > :-)
> 
> But first, deprecate it!

No need, it's already marked __deprecated ;-)

	Ingo
