Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757107Ab1JOAfO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 20:35:14 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:43399 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754499Ab1JOAfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 20:35:12 -0400
Date: Fri, 14 Oct 2011 20:34:56 -0400 (EDT)
Message-Id: <20111014.203456.760074223041131268.davem@davemloft.net>
To: crn@netunix.com
Cc: pebolle@tiscali.nl, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/21] sparc: drop unused Kconfig symbol
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LNX.2.00.1110150111520.26030@post.netunix.com>
References: <1318595257.6132.59.camel@x61.thuisdomein>
	<alpine.LNX.2.00.1110150111520.26030@post.netunix.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 14 Oct 2011 17:34:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: crn@netunix.com
Date: Sat, 15 Oct 2011 01:14:02 +0100 (BST)

> 
> How does this affect Javastations, ISTR that they need PCI and one
> (rare) variant has a PCI slot. ??

How about you take even the briefest look at the code and find out for
yourself?  This is what drives me crazy about the questions you tend
to ask, you never put forth any effort of investigation on your own
and just toss arbitrary questions onto the list.

Meanwhile those of us with initiative are burdoned to do the work for
you.

The config symbol is completely unreferenced anywhere, so this
change can't possibly make any functional difference whatsoever.
