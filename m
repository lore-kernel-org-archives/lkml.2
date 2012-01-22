Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516Ab2AVThf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 14:37:35 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:49083 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025Ab2AVThe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 14:37:34 -0500
Date: Sun, 22 Jan 2012 14:37:28 -0500 (EST)
Message-Id: <20120122.143728.1710688129934394279.davem@davemloft.net>
To: maciej.rutecki@gmail.com
Cc: davej@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        rjw@sisk.pl
Subject: Re: recvmsg sleeping from invalid context
From: David Miller <davem@davemloft.net>
In-Reply-To: <201201222031.51116.maciej.rutecki@gmail.com>
References: <201201220854.59968.maciej.rutecki@gmail.com>
	<20120122.141006.530154674609252253.davem@davemloft.net>
	<201201222031.51116.maciej.rutecki@gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 22 Jan 2012 11:37:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maciej Rutecki <maciej.rutecki@gmail.com>
Date: Sun, 22 Jan 2012 20:31:51 +0100

> These entries are using for tracking regressions, for *all* kernel parts, 
> without any exception. I see no reason to treat someone differently. If netdev 
> provides any interface to tracking regressions, then show me it. But then why 
> you do not use one common tool for all kernel?

This mailing list is the tracking mechanism.

You can create whatever you want, but I can guarentee that the very
people who can actually move the bug forward and fix the problem will
look at it.

It's been like this for ages, Andrew Morton understands how we wish
to track bugs, and that we don't want to use bugzilla for that purpose.
