Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab0H1RMn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 13:12:43 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:39421 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992Ab0H1RMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 13:12:42 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4C79435B.2030303@s5r6.in-berlin.de>
Date: Sat, 28 Aug 2010 19:11:55 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100627 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: David Brownell <david-b@pacbell.net>,
        Thomas Dahlmann <dahlmann.thomas@arcor.de>,
        kernel-janitors@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-geode@lists.infradead.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] drivers/usb/gadget: Remove double test
References: <581556.29157.qm@web180314.mail.gq1.yahoo.com> <Pine.LNX.4.64.1008281852450.13508@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.1008281852450.13508@ask.diku.dk>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall wrote:
> On Sat, 28 Aug 2010, David Brownell wrote:
> 
>> Please update $SUBJECT to say which driver is
>> affected;
> 
> Done.
> 
>> it's not everything in that directory,
>> and accurate GIT summaries help a lot.
> 
> Is there some sort of rule that can be followed?  For example, if the 
> patch affects only one, file, should that file be named?  What if the 
> patch affects only two files?

gitk $path or git shortlog $path, with $path being the file or directory, give
a quick impression how the resident developers call their driver or subsystem
updates.  E.g. ^USB: instead of ^drivers/usb/.

However, the committer could still adjust the title, so no drama if the patch
subject as written by a cross-tree developer looks different from those of the
usual subsystem patches.  IMO this is one of the tasks of a subsystem
maintainer.  And it is quickly enough done with a git commit --amend.

There is only a drawbackif the subject is too broad /and/ if the Cc list is
too short;  a driver developer may miss to see the submission.  The danger of
that is low though when get_maintainer.pl is used to good effect.
-- 
Stefan Richter
-=====-==-=- =--- ===--
http://arcgraph.de/sr/
