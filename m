Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483Ab2B0Abt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 19:31:49 -0500
Received: from mail1.windriver.com ([147.11.146.13]:41393 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381Ab2B0Abr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 19:31:47 -0500
Date: Sun, 26 Feb 2012 19:30:38 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Mike Frysinger <vapier@gentoo.org>
CC: <JBottomley@parallels.com>, <jejb@parisc-linux.org>, <kyle@mcmartin.ca>,
        <deller@gmx.de>, <linux-parisc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-next@vger.kernel.org>
Subject: Re: [PATCH] parisc: dont unconditionally override CROSS_COMPILE for
 64 bit.
Message-ID: <20120227003037.GE21842@windriver.com>
References: <1330298813-17262-1-git-send-email-paul.gortmaker@windriver.com>
 <201202261923.15167.vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <201202261923.15167.vapier@gentoo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Re: [PATCH] parisc: dont unconditionally override CROSS_COMPILE for 64 bit.] On 26/02/2012 (Sun 19:23) Mike Frysinger wrote:

> On Sunday 26 February 2012 18:26:53 Paul Gortmaker wrote:
> > --- a/arch/parisc/Makefile
> > +++ b/arch/parisc/Makefile
> >
> > -CROSS_COMPILE	:= hppa64-linux-gnu-
> > +ifndef CROSS_COMPILE
> > + CROSS_COMPILE	:= hppa64-linux-gnu-
> > +endif
> 
> this should accomplish the same thing in practice:
> 	CROSS_COMPILE ?= hppa64-linux-gnu-

Good point, I'll wait for a bit in case I was missing something else
obvious, and then resend.

THanks,
P.

> -mike


