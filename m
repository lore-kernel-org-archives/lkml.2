Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751393Ab2EXEx0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 00:53:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50068 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944Ab2EXExY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 00:53:24 -0400
Date: Wed, 23 May 2012 21:53:21 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch -linus] regmap: REMAP_IRQ should select IRQ_DOMAIN
 itself
In-Reply-To: <20120524011950.GD5361@opensource.wolfsonmicro.com>
Message-ID: <alpine.DEB.2.00.1205232149230.10366@chino.kir.corp.google.com>
References: <20120522183037.75ec03c9d8881ec188e7f787@canb.auug.org.au> <4FBBAF1B.1070702@xenotime.net> <alpine.DEB.2.00.1205222339030.9290@chino.kir.corp.google.com> <20120523093208.GB4085@opensource.wolfsonmicro.com> <CA+55aFynyjrHUCh48aXSQpZpboQM7MCCtMHvxBxCf+gDoCVWXg@mail.gmail.com>
 <20120523173342.GB4064@opensource.wolfsonmicro.com> <alpine.DEB.2.00.1205231735100.8785@chino.kir.corp.google.com> <20120524011950.GD5361@opensource.wolfsonmicro.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2012, Mark Brown wrote:

> > What's fragile is going around and adding "select IRQ_DOMAIN" to 
> > everything that does "select REGMAP_IRQ".  So I removed that and just made 
> > IRQ_DOMAIN select REGMAP_IRQ itself.
> 
> It's a different kind of fragility, things break immediately when you
> add something new which is reasonably obvous as opposed to happening
> at some other time due to a tooling issue and what I'm concerned about
> avoiding.  In any case...
> 

Well pardon me for actually having a cluster of machines at Google 
dedicated to upstream build/boot/regression testing that verified my patch 
was correct and didn't result in any kind of "fragility", or what you have 
convinced yourself is "fragility."

> > So can this be merged or what's the issue?
> 
> ...Linus already merged my alternative patch which does this with a
> select..if which never seems to have these issues.
> 

When you propose your own version, drop all cc's (and this isn't the first 
time you've done that), and then send the git pull request less than 30 
minutes later, I don't really have the chance to review it.  Lesson 
learned, I simply won't bother to fix your code in the future.
