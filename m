Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564Ab2D2VEE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 17:04:04 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:44521 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784Ab2D2VEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 17:04:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bojan Smojver <bojan@rexursive.com>
Subject: Re: [PATCH v11]: Hibernation: fix the number of pages used for hibernate/thaw buffering
Date: Sun, 29 Apr 2012 23:08:43 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Per Olofsson <pelle@debian.org>, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>
References: <1334267969.2573.14.camel@shrek.rexursive.com> <1335485772.2136.21.camel@shrek.rexursive.com> <1335486369.2136.24.camel@shrek.rexursive.com>
In-Reply-To: <1335486369.2136.24.camel@shrek.rexursive.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201204292308.43593.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, April 27, 2012, Bojan Smojver wrote:
> On Fri, 2012-04-27 at 10:16 +1000, Bojan Smojver wrote:
> > Here it is.
> 
> So, a quick summary:
> 
> These patches should go to linux-pm/linux-next (in that order):
> 
> http://marc.info/?l=linux-kernel&m=133522096505280&w=2
> http://marc.info/?l=linux-kernel&m=133548592706940&w=2

Both are in my linux-next branch.

> Only this patch should to to -stable:
> 
> http://marc.info/?l=linux-kernel&m=133522096505280&w=2

And this one is in my fixes branch in addition and will be pushed to Linus
shortly.

Thanks,
Rafael
