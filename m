Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab0H1RRU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 13:17:20 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:44522 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753029Ab0H1RRS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 13:17:18 -0400
Date: Sat, 28 Aug 2010 19:17:16 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: David Brownell <david-b@pacbell.net>,
        Thomas Dahlmann <dahlmann.thomas@arcor.de>,
        kernel-janitors@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-geode@lists.infradead.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] drivers/usb/gadget: Remove double test
In-Reply-To: <4C79435B.2030303@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.64.1008281916580.13508@ask.diku.dk>
References: <581556.29157.qm@web180314.mail.gq1.yahoo.com>
 <Pine.LNX.4.64.1008281852450.13508@ask.diku.dk> <4C79435B.2030303@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Aug 2010, Stefan Richter wrote:

> Julia Lawall wrote:
> > On Sat, 28 Aug 2010, David Brownell wrote:
> > 
> >> Please update $SUBJECT to say which driver is
> >> affected;
> > 
> > Done.
> > 
> >> it's not everything in that directory,
> >> and accurate GIT summaries help a lot.
> > 
> > Is there some sort of rule that can be followed?  For example, if the 
> > patch affects only one, file, should that file be named?  What if the 
> > patch affects only two files?
> 
> gitk $path or git shortlog $path, with $path being the file or directory, give
> a quick impression how the resident developers call their driver or subsystem
> updates.  E.g. ^USB: instead of ^drivers/usb/.
> 
> However, the committer could still adjust the title, so no drama if the patch
> subject as written by a cross-tree developer looks different from those of the
> usual subsystem patches.  IMO this is one of the tasks of a subsystem
> maintainer.  And it is quickly enough done with a git commit --amend.
> 
> There is only a drawbackif the subject is too broad /and/ if the Cc list is
> too short;  a driver developer may miss to see the submission.  The danger of
> that is low though when get_maintainer.pl is used to good effect.

OK, thanks.

julia
