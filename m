Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488Ab2CSEOu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 00:14:50 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:56465 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174Ab2CSEOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 00:14:48 -0400
Date: Mon, 19 Mar 2012 00:14:30 -0400 (EDT)
Message-Id: <20120319.001430.1735750114727679638.davem@davemloft.net>
To: tytso@mit.edu
Cc: joe@perches.com, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/9] ext4: Use pr_fmt and pr_<level>
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120319040950.GG31682@thunk.org>
References: <cover.1331856299.git.joe@perches.com>
	<ceb0e02f9f0c1548a654e8718fbadc147595f8ee.1331856300.git.joe@perches.com>
	<20120319040950.GG31682@thunk.org>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 18 Mar 2012 21:14:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ted Ts'o" <tytso@mit.edu>
Date: Mon, 19 Mar 2012 00:09:50 -0400

> Changing printk's to pr_info and pr_cont is patch noise as far as I'm
> concerned.

Ted, get off your high horse.

I apply patches like Joe's all the time to the networking, consistency
has high value whether you choose to believe it or not.  And no we
don't have huge problems with patch conflicts and stuff like that
either, it simply isn't a real issue so don't use that as an excuse
either.

