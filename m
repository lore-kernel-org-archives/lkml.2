Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757619Ab0ERSxj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 14:53:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41496 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755540Ab0ERSxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 14:53:37 -0400
Date: Tue, 18 May 2010 20:53:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joe Perches <joe@perches.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bluesmoke-devel@lists.sourceforge.net,
       Linux Edac Mailing List <linux-edac@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Ben Woodard <woodard@redhat.com>, Matt Domsch <Matt_Domsch@dell.com>,
       Doug Thompson <dougthompson@xmission.com>,
       Borislav Petkov <bp@amd64.org>, Tony Luck <tony.luck@intel.com>,
       Brent Young <brent.young@intel.com>
Subject: Re: Hardware Error Kernel Mini-Summit
Message-ID: <20100518185305.GA23921@elte.hu>
References: <4BF18995.6070008@redhat.com>
 <4BF2392A.9040409@jp.fujitsu.com>
 <4BF2C3D1.10009@redhat.com>
 <1274204560.17703.82.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274204560.17703.82.camel@Joe-Laptop.home>
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


* Joe Perches <joe@perches.com> wrote:

> On Tue, 2010-05-18 at 13:44 -0300, Mauro Carvalho Chehab wrote:
> > IMO, the first
> > step is to provide an error core integrated to perf, and then start
> > integrating the several error systems around it.
> 
> Why integrated to perf?

It makes sense to use the kernel's performance events 
logging framework when we are logging events about how the 
system performs.

Furthermore it's NMI safe, offers structured logging, has 
various streaming, multiplexing and filtering capabilities 
that come handy for RAS purposes and more.

The other option would be to use an ad-hoc logging 
implementation, only used for EDAC/RAS, which couldnt be 
mixed with other system events. That approach has various 
obvious disadvanteges so we are aiming for a unified 
approach.

Thanks,

	Ingo
