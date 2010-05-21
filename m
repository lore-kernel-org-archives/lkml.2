Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758174Ab0EUVIl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 17:08:41 -0400
Received: from ist.d-labs.de ([213.239.218.44]:33162 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752175Ab0EUVIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 17:08:40 -0400
Date: Fri, 21 May 2010 23:08:23 +0200
From: Florian Mickler <florian@mickler.org>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Hemminger <shemminger@vyatta.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] get_maintainer.pl: improve config-file support
Message-ID: <20100521230823.7f0a0200@schatten.dmk.lab>
In-Reply-To: <1274473288.8140.569.camel@Joe-Laptop.home>
References: <1273698720-4010-1-git-send-email-florian@mickler.org>
	<1273703333.20514.392.camel@Joe-Laptop.home>
	<20100513095652.34aea727@schatten.dmk.lab>
	<20100520084615.6e2efa38@schatten.dmk.lab>
	<20100521131303.ad40e6d8.akpm@linux-foundation.org>
	<1274473288.8140.569.camel@Joe-Laptop.home>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 May 2010 13:21:28 -0700
Joe Perches <joe@perches.com> wrote:

> On Fri, 2010-05-21 at 13:13 -0700, Andrew Morton wrote:
> > On Thu, 20 May 2010 08:46:15 +0200
> > Florian Mickler <florian@mickler.org> wrote:
> > > What's the status of this patch?
> > > Do you take it, or do you have an issue with it? This is a clear
> > > improvement in my opinion.
> > Joe didn't sound very excited about it.
> > If we're going to do this, we should hurry up, please - it'd be silly
> > to introduce a config file and then change its format shortly
> > afterwards.
> 
> If an ".ini" style config is used, I think it'd be better to
> put this stuff in .git/config under a proper section so that
> any checking style script (checkpatch, smatch, smpl, etc)
> has a standard place to put stuff.
> 
> I think what I posted requires less overall work and doesn't
> need updating every time a new option is added, but overall
> the capability isn't all that necessary.

Feature-like it is the same. But in my opinion my solution with a
key=value approach (why .ini? where did you get that from?) is more
obvious. 
I've never seen this hacky thing where you put "--option" tokens in
a file in my life. 
Of course, Joe's solution is short and to the point.
But i would consider it more "quick'n'dirty" than elegant.

As for the placement:
This has nothing to do with git, aside from using it as a _possible_
way to determine the maintainers. So I doubt that we should
mess with .git/config. If you want to go that road of a more general
solution, a common /scripts/ config-file would be more realistic.

Cheers,
Flo

