Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312Ab2EXJKG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 05:10:06 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42944 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932242Ab2EXJKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 05:10:01 -0400
Date: Thu, 24 May 2012 10:09:58 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: David Rientjes <rientjes@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch -linus] regmap: REMAP_IRQ should select IRQ_DOMAIN itself
Message-ID: <20120524090957.GE5361@opensource.wolfsonmicro.com>
References: <20120522183037.75ec03c9d8881ec188e7f787@canb.auug.org.au>
 <4FBBAF1B.1070702@xenotime.net>
 <alpine.DEB.2.00.1205222339030.9290@chino.kir.corp.google.com>
 <20120523093208.GB4085@opensource.wolfsonmicro.com>
 <CA+55aFynyjrHUCh48aXSQpZpboQM7MCCtMHvxBxCf+gDoCVWXg@mail.gmail.com>
 <20120523173342.GB4064@opensource.wolfsonmicro.com>
 <alpine.DEB.2.00.1205231735100.8785@chino.kir.corp.google.com>
 <20120524011950.GD5361@opensource.wolfsonmicro.com>
 <alpine.DEB.2.00.1205232149230.10366@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1205232149230.10366@chino.kir.corp.google.com>
X-Cookie: You will get what you deserve.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 09:53:21PM -0700, David Rientjes wrote:

> Well pardon me for actually having a cluster of machines at Google 
> dedicated to upstream build/boot/regression testing that verified my patch 
> was correct and didn't result in any kind of "fragility", or what you have 
> convinced yourself is "fragility."

It working right now isn't the only thing I'm concerned about, though
like I said further up the thread it's possible this is all just me
having too long a memory.

> When you propose your own version, drop all cc's (and this isn't the first 
> time you've done that), and then send the git pull request less than 30 

Sorry about that, I hadn't realised you were particularly attached to
the issue.  I do generally drop people doing global stuff with no
particular obvious interest in the specific topic on new patches since I
know I sometimes get a bit fed up of being CCed on random things I was
tangentially involved in at some point.

> minutes later, I don't really have the chance to review it.  Lesson 
> learned, I simply won't bother to fix your code in the future.

I guess since I've offended you so much already there's not much harm in
saying: it's always much better to send changes in a form that can be
directly applied with tools like git am.  Appending a patch to the
bottom of a mail requires something like hand editing the commit after
it's been applied to extract the changelog.  Not sure it actually made a
difference in this specific case but it can be the difference when
you're not sure about the approach taken, especially for small patches
where it's quick and simple to write and test the replacement.
