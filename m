Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759431Ab2DZWGm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 18:06:42 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:39944 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758866Ab2DZWGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 18:06:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bojan Smojver <bojan@rexursive.com>
Subject: Re: [PATCH v11]: Hibernation: fix the number of pages used for hibernate/thaw buffering
Date: Fri, 27 Apr 2012 00:11:20 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Per Olofsson <pelle@debian.org>, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>
References: <1334267969.2573.14.camel@shrek.rexursive.com> <201204262200.32663.rjw@sisk.pl> <1335474828.2136.15.camel@shrek.rexursive.com>
In-Reply-To: <1335474828.2136.15.camel@shrek.rexursive.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201204270011.20430.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 26, 2012, Bojan Smojver wrote:
> On Thu, 2012-04-26 at 22:00 +0200, Rafael J. Wysocki wrote:
> 
> > No, I didn't requested that.  There's nothing like stable-only patches,
> > we only backport mainline commits to -stable.
> 
> Yeah, you told me that my patch was not straightforward, so I broke off
> part of it for -stable that would fix just the most critical problem.

Which is entirely OK, but see below.

> > > This patch should go to linux-next:
> > > 
> > > http://marc.info/?l=linux-kernel&m=133426808115262&w=2
> > 
> > OK
> > 
> > So I'll include it into my v3.5 push and I don't want to hear about how
> > urgent it is any more.  Is that clear enough?
> 
> Look, I created a problem on some people's computer in 3.2. I feel
> responsible for fixing it. I do not want their computers to hang because
> of something I wrote, especially if there is a fix.
> 
> So, if I will say one more time. This patch is a fix for a regression,
> caused by me, since 3.2. Please ask -stable maintainers to include it in
> version in 3.2 and above.

The -stable rules are such that it only is permitted to put a commit into
-stable if the analogous commit is already in the mainline.  That also
covers reverts and such.

> If you want me to create a set of patches instead and then you backport
> just one, let me know. I will do whatever is necessary to fix this
> regression.

Can you just create a second patch on top of what's in linux-next now?

Rafael
