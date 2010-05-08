Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462Ab0EHXvL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 19:51:11 -0400
Received: from mail.perches.com ([173.55.12.10]:2071 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751960Ab0EHXvJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 19:51:09 -0400
Subject: Re: [PATCH] [RFC] get_maintainer.pl: only list maintainers by
 default
From: Joe Perches <joe@perches.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: florian@mickler.org, Andrew Morton <akpm@linux-foundation.org>,
       Stephen Hemminger <shemminger@vyatta.com>, linux-kernel@vger.kernel.org
In-Reply-To: <4BE5F286.1020503@s5r6.in-berlin.de>
References: <1273354364-6016-1-git-send-email-florian@mickler.org>
	 <1273354778-6129-1-git-send-email-florian@mickler.org>
	 <1273358674.704.77.camel@Joe-Laptop.home>
	 <4BE5F286.1020503@s5r6.in-berlin.de>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 08 May 2010 16:51:06 -0700
Message-ID: <1273362666.704.104.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-05-09 at 01:23 +0200, Stefan Richter wrote:
> Joe Perches wrote:
> Reported-by and tested-by signatures in the git history commit /are/ in
> fact random WRT getting a list of handlers/ reviewers of a new patch.

Supporting stats please.

$ git log --since=1-year-ago | grep -Pi "(reported|tested)-by:.*@" \
  | cut -f2- -d":" | sort | uniq -c | sort -rn | head -10
     77  Ingo Molnar <mingo@elte.hu>
     47  Wolfram Sang <w.sang@pengutronix.de>
     42  Stephen Rothwell <sfr@canb.auug.org.au>
     35  Dan Carpenter <error27@gmail.com>
     24  Randy Dunlap <randy.dunlap@oracle.com>
     23  Larry Finger <Larry.Finger@lwfinger.net>
     20  Brian Cavagnolo <brian@cozybit.com>
     17  Frans Pop <elendil@planet.nl>
     17  Christian Kujau <lists@nerdbynature.de>
     16  Alexander Beregalov <a.beregalov@gmail.com>

Look like mostly patch authors and maintainers to me.

Brian Cavagnolo isn't a patch author, but he's an active tester.

> It is more likely that reporters and testers cannot or/and do not want to
> do anything about such a patch.  Such a mailing is called UBE.

I doubt that's true of even half of the reporters and testers.

I also doubt such patch emails fit any reasonable definition
of UBE.

cheers, Joe

