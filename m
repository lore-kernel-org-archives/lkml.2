Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275Ab0ETMht (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 08:37:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38579 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733Ab0ETMhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 08:37:47 -0400
Date: Thu, 20 May 2010 14:37:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Borislav Petkov <bp@amd64.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       "Young, Brent" <brent.young@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Matt Domsch <Matt_Domsch@dell.com>,
       Doug Thompson <dougthompson@xmission.com>,
       Joe Perches <joe@perches.com>,
       "bluesmoke-devel@lists.sourceforge.net" 
	<bluesmoke-devel@lists.sourceforge.net>,
       Linux Edac Mailing List <linux-edac@vger.kernel.org>
Subject: Re: Hardware Error Kernel Mini-Summit
Message-ID: <20100520123716.GA2040@elte.hu>
References: <1274204560.17703.82.camel@Joe-Laptop.home>
 <20100518185305.GA23921@elte.hu>
 <987664A83D2D224EAE907B061CE93D53C61D1C57@orsmsx505.amr.corp.intel.com>
 <20100518191802.GG25224@aftab>
 <m1k4r0c0y7.fsf@fess.ebiederm.org>
 <20100518222832.GJ22675@basil.fritz.box>
 <m1wrv0zo9q.fsf@fess.ebiederm.org>
 <20100519064619.GA30320@aftab>
 <20100519070919.GA9618@elte.hu>
 <4BF3D17F.5000605@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BF3D17F.5000605@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0003]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mauro Carvalho Chehab <mchehab@redhat.com> wrote:

> Ingo Molnar wrote:
>
> > Regarding dmesg, there's a WIP patch on lkml that 
> > integrates printks into this framework as well - makes 
> > each printk also available as a special string event.
> > 
> > That way a tool can have both programmatic access to 
> > printk output (without having to interact with the 
> > syslog buffer itself) - together with all the other 
> > structured log sources, while humans can also see what 
> > is happening.
> 
> Some system admins prefer to have everything on dmesg, 
> as they can enable a serial console, and catch the logs 
> remotely, even when the machine crashes for example due 
> to a hardware failure.
> 
> So, IMHO, one feature that the perf event needs is the 
> capability to report errors via a serial console also, 
> or a mechanism where some events are sent via dmesg.

Yeah. That can be an aspect of the callback - or might 
even be integrated into the core code.

Thanks,

	Ingo
