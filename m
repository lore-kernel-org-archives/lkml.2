Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757958Ab0EVSdY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 14:33:24 -0400
Received: from www.tglx.de ([62.245.132.106]:33534 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755801Ab0EVSdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 14:33:23 -0400
Date: Sat, 22 May 2010 20:32:42 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       John Stultz <johnstul@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Regression] Negative time on Acer Ferrari One with current
 -git
In-Reply-To: <alpine.LFD.2.00.1005222020570.3368@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1005222032080.3368@localhost.localdomain>
References: <201005212343.25184.rjw@sisk.pl> <alpine.LFD.2.00.1005221429360.3368@localhost.localdomain> <alpine.LFD.2.00.1005221616310.3368@localhost.localdomain> <201005221934.09705.rjw@sisk.pl> <alpine.LFD.2.00.1005222020570.3368@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 May 2010, Thomas Gleixner wrote:

> On Sat, 22 May 2010, Rafael J. Wysocki wrote:
> > On Saturday 22 May 2010, Thomas Gleixner wrote:
> > 
> > > Also which clocksource is used ?
> > 
> > hpet
> 
> Hmm, there is only one hpet related commit sin .34:  30a564be9d
> and I can hardly see how this should be related.

Does the problem persist if you disable HPET on the kernel command line ?
 
Thanks,

	tglx

