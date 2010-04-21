Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119Ab0DUOZL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 10:25:11 -0400
Received: from lazybastard.de ([212.112.238.170]:55488 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755005Ab0DUOZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 10:25:10 -0400
Date: Wed, 21 Apr 2010 16:24:56 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Linus <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Please pull logfs tree for fixes
Message-ID: <20100421142456.GC18441@logfs.org>
References: <20100421121932.GA18441@logfs.org> <1271858963.2058.4.camel@m0nster>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1271858963.2058.4.camel@m0nster>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 April 2010 07:09:22 -0700, Daniel Walker wrote:
> On Wed, 2010-04-21 at 14:19 +0200, Jörn Engel wrote:
> > Another set of fixes.  Two of them are security relevant.  But given
> > that an attacker needs mount access and few people have logfs compiled
> > in, that's unlikely to be a huge issue.
> > 
> >  gc.c        |    8 ++++++
> >  journal.c   |   29 ++++++++++++++---------
> >  logfs.h     |   15 ++++++++++--
> >  readwrite.c |   75 +++++++++++++++++++++++++++++++++---------------------------
> >  segment.c   |    8 ------
> >  super.c     |   11 +++++++-
> >  6 files changed, 91 insertions(+), 55 deletions(-)
> 
> Where is the url for your tree? There's a git command,

Doh!

git://git.kernel.org/pub/scm/linux/kernel/git/joern/logfs.git

> "git request-pull"
> 
> It spits out a form email with url , and all the needed info.

Nice.  Guess I'll use that from now on.  Thanks!

Jörn

-- 
"Translations are and will always be problematic. They inflict violence
upon two languages." (translation from German)
