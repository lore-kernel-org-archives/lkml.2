Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933214Ab0JRVGA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 17:06:00 -0400
Received: from fifo99.com ([67.223.236.141]:36281 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750806Ab0JRVF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 17:05:59 -0400
Subject: Re: linux-next: manual merge of the msm tree with the arm tree
From: Daniel Walker <dwalker@fifo99.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Nicolas Pitre <nico@fluxnic.net>, Russell King <rmk@arm.linux.org.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jeremy Kerr <jeremy.kerr@canonical.com>,
        Jeff Ohlstein <johlstei@codeaurora.org>
In-Reply-To: <201010182248.36078.arnd@arndb.de>
References: <20101018103540.7bd9c535.sfr@canb.auug.org.au>
	 <201010182219.25890.arnd@arndb.de>
	 <1287434251.5588.23.camel@c-dwalke-linux.qualcomm.com>
	 <201010182248.36078.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Oct 2010 14:05:28 -0700
Message-ID: <1287435928.5588.37.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-18 at 22:48 +0200, Arnd Bergmann wrote:
> On Monday 18 October 2010 22:37:31 Daniel Walker wrote:
> > > When you know that Russell does not rebase his tree, you can pull his
> > > tree into yours whenever a change hits his tree that impacts you in
> > > a major way. You shouldn't do this too frequently, but it's a good way
> > > to resolve conflicts like this one.
> > 
> > If I did that all of Russell's changesets would get mixed with mine when
> > I send the pull request .. That would just create confusion .. It's OK
> > if Russell sends my commits to Linus, but I'm not going to send
> > Russell's commits.
> 
> Actually both are ok, as long as you as the sub-maintainer send your
> pull request after Russell's tree has been merged and you don't
> ask anyone else to pull your tree who has not pulled Russell's tree
> explicitly or implicitly through Linus.
> 
> git-request-pull is smart enough to list only the changesets that
> are not in the upstream tree, as will git "log your-branch...upstream"
> or "git diff your-branch upstream".

I guess your assuming I send my pull request after Russell's, which
isn't necessarily true, and I'd rather not have that dependency if I
don't have to. 

Even with a one time event what your suggesting seems like it would be
some what freaky. I wouldn't want to wait around for Russell to get his
tree merged before I can get a reasonable log of my own activities
(without jumping through hoops).

Of course I could do what your suggesting, I just don't think it's the
easiest way to fix this.

Daniel

