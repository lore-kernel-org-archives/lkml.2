Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848Ab0FIIS1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 04:18:27 -0400
Received: from mail.gmx.net ([213.165.64.20]:44690 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755584Ab0FIIS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 04:18:26 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19ta0IrBc1t5xClTEyImZ5apDr0nE3uhFhjaRqe2t
	u/4vaZHs70fshd
Subject: Re: kbuild: Fix the breakage caused by "improve version string
 logic"
From: Mike Galbraith <efault@gmx.de>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: David Rientjes <rientjes@google.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Frans Pop <elendil@planet.nl>,
       Dirk Hohndel <hohndel@infradead.org>, Len Brown <lenb@kernel.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <4C0F489F.4020204@panasas.com>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain>
	 <alpine.LFD.2.00.0910052140100.309@localhost.localdomain>
	 <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com>
	 <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain>
	 <20091006144449.GA23078@elte.hu>
	 <alpine.LFD.2.01.0910060815320.3432@localhost.localdomain>
	 <20091006153632.GA29795@elte.hu>
	 <alpine.LFD.2.01.0910060843560.3432@localhost.localdomain>
	 <alpine.LFD.2.01.0910060925490.3432@localhost.localdomain>
	 <20091006173508.GA4786@elte.hu> <20091012195733.GA7351@elte.hu>
	 <4C0D29DE.6050602@panasas.com>
	 <alpine.DEB.2.00.1006071242510.30389@chino.kir.corp.google.com>
	 <4C0DFFFF.1010704@panasas.com>
	 <alpine.DEB.2.00.1006080200190.18052@chino.kir.corp.google.com>
	 <4C0E17F0.5010902@panasas.com>
	 <alpine.DEB.2.00.1006082352120.30606@chino.kir.corp.google.com>
	 <4C0F489F.4020204@panasas.com>
Content-Type: text/plain
Date: Wed, 09 Jun 2010 10:18:20 +0200
Message-Id: <1276071500.9435.14.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-09 at 10:54 +0300, Boaz Harrosh wrote:

> But it seems I will not be granted my wish. I'll go damage my
> scripts/setlocalversion and be done with this.

I dislike that annoying little <expletive deleted> '+' too, but I have
to edit Makefile constantly to whack -rc and set version to the _right_
number as defined by me anyway, so it doesn't matter much.

Thank goodness we have _something_ to gripe about :)

	-Mike

