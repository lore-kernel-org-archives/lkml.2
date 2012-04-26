Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759102Ab2DZTzx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 15:55:53 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:39644 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758597Ab2DZTzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 15:55:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bojan Smojver <bojan@rexursive.com>
Subject: Re: [PATCH v11]: Hibernation: fix the number of pages used for hibernate/thaw buffering
Date: Thu, 26 Apr 2012 22:00:32 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Per Olofsson <pelle@debian.org>, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>
References: <1334267969.2573.14.camel@shrek.rexursive.com> <201204250012.00544.rjw@sisk.pl> <1335410904.2136.9.camel@shrek.rexursive.com>
In-Reply-To: <1335410904.2136.9.camel@shrek.rexursive.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201204262200.32663.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 26, 2012, Bojan Smojver wrote:
> On Wed, 2012-04-25 at 00:12 +0200, Rafael J. Wysocki wrote:
> > Applied to linux-pm/linux-next.
> 
> Yeah, that was the wrong thing to do. The simpler patch I sent was for
> stable only, as you requested.

No, I didn't requested that.  There's nothing like stable-only patches,
we only backport mainline commits to -stable.

> This patch should go to linux-next:
> 
> http://marc.info/?l=linux-kernel&m=133426808115262&w=2

OK

So I'll include it into my v3.5 push and I don't want to hear about how
urgent it is any more.  Is that clear enough?

Rafael
