Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517Ab0IJKE3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 06:04:29 -0400
Received: from mail.perches.com ([173.55.12.10]:1624 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751542Ab0IJKE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 06:04:27 -0400
Subject: Re: [PATCH] get_maintainer.pl: append reason for cc to the name by
 default
From: Joe Perches <joe@perches.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: florian@mickler.org, Andrew Morton <akpm@linux-foundation.org>,
        "Stephen Hemminger (role:commit_signer)" <shemminger@vyatta.com>,
        "Wolfram Sang (role:commit_signer)" <w.sang@pengutronix.de>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20100910095259.GC23903@sirena.org.uk>
References: <1284111212-10659-1-git-send-email-florian@mickler.org>
	 <1284111767.1783.35.camel@Joe-Laptop>
	 <20100910095259.GC23903@sirena.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Sep 2010 03:04:26 -0700
Message-ID: <1284113066.1783.69.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-10 at 10:53 +0100, Mark Brown wrote:
> On Fri, Sep 10, 2010 at 02:42:47AM -0700, Joe Perches wrote:
> > As the coverage of file patterns in MAINTAINERS is
> > now pretty good, the --git results are less useful.
> It's pretty good for subsystems and PC drivers but for embedded stuff it
> is much more patchy and fairly unlikely to find someone who actually
> knows about the specific hardware.

Especially not so good for ARM stuff.

It'd be great if the ARM/embedded folk would spend
some effort improving the MAINTAINERS file pattern
coverage.

I wrote some scripts to compare files and git commits
to the individuals listed in MAINTAINERS as well as
the "first author" of files added vs email addresses
contained in the files.  Some nominal MAINTAINERS
haven't had commits or signoffs in quite awhile and
could be likely be sifted out.

One possible improvement that get_maintainers could
add is to [optionally] CC the author of the first
commit when there's no listed maintainer.

