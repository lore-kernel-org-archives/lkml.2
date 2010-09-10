Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597Ab0IJKWQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 06:22:16 -0400
Received: from ist.d-labs.de ([213.239.218.44]:40343 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891Ab0IJKWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 06:22:15 -0400
Date: Fri, 10 Sep 2010 12:22:13 +0200
From: Florian Mickler <florian@mickler.org>
To: Joe Perches <joe@perches.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Stephen Hemminger (role:commit_signer)" <shemminger@vyatta.com>,
        "Wolfram Sang (role:commit_signer)" <w.sang@pengutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] get_maintainer.pl: append reason for cc to the name by
 default
Message-ID: <20100910122213.30caee89@schatten.dmk.lab>
In-Reply-To: <1284113066.1783.69.camel@Joe-Laptop>
References: <1284111212-10659-1-git-send-email-florian@mickler.org>
	<1284111767.1783.35.camel@Joe-Laptop>
	<20100910095259.GC23903@sirena.org.uk>
	<1284113066.1783.69.camel@Joe-Laptop>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Sep 2010 03:04:26 -0700
Joe Perches <joe@perches.com> wrote:

> On Fri, 2010-09-10 at 10:53 +0100, Mark Brown wrote:
> > On Fri, Sep 10, 2010 at 02:42:47AM -0700, Joe Perches wrote:
> > > As the coverage of file patterns in MAINTAINERS is
> > > now pretty good, the --git results are less useful.
> > It's pretty good for subsystems and PC drivers but for embedded stuff it
> > is much more patchy and fairly unlikely to find someone who actually
> > knows about the specific hardware.
> 
> Especially not so good for ARM stuff.
> 
> It'd be great if the ARM/embedded folk would spend
> some effort improving the MAINTAINERS file pattern
> coverage.

hm.. not likely to happen.

> One possible improvement that get_maintainers could
> add is to [optionally] CC the author of the first
> commit when there's no listed maintainer.
> 

I don't think the first commit has any special significance 
in general. 

