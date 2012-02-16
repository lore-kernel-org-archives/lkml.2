Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291Ab2BPVdS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 16:33:18 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:43624 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab2BPVdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 16:33:16 -0500
Date: Thu, 16 Feb 2012 16:33:03 -0500 (EST)
Message-Id: <20120216.163303.443981736744424334.davem@davemloft.net>
To: padovan@profusion.mobi
Cc: joe@perches.com, marcel@holtmann.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] bluetooth: Use more current logging styles
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120216180507.GA5280@joana>
References: <1329184963.8143.2.camel@joe2Laptop>
	<1329410631.10890.3.camel@joe2Laptop>
	<20120216180507.GA5280@joana>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 16 Feb 2012 13:33:08 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gustavo Padovan <padovan@profusion.mobi>
Date: Thu, 16 Feb 2012 16:05:07 -0200

> Such a change will require rebase from all our developers and we already have
> enough issues to solve, I don't wanna add one more here. Change what BT_*
> stands for is ok, but there is no need to change the macros names. 

I would never push back on Joe on a change like this, the way that
you are, and changes in my tree have an effect on 100 times more
people than your's.

You're being completely unreasonable, and I'm rather confident that in
response to what I'm saying you will simply start pulling more reasons
out of thin air simply because you just don't want the change and the
merge hassles.
