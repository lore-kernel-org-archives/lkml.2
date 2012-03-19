Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169Ab2CSFNv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 01:13:51 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:56847 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700Ab2CSFNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 01:13:50 -0400
Date: Mon, 19 Mar 2012 01:13:44 -0400 (EDT)
Message-Id: <20120319.011344.1171767169678830328.davem@davemloft.net>
To: tytso@mit.edu
Cc: joe@perches.com, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/9] ext4: Use pr_fmt and pr_<level>
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120319045514.GQ31682@thunk.org>
References: <cover.1331856299.git.joe@perches.com>
	<ceb0e02f9f0c1548a654e8718fbadc147595f8ee.1331856300.git.joe@perches.com>
	<20120319045514.GQ31682@thunk.org>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 18 Mar 2012 22:13:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ted Ts'o" <tytso@mit.edu>
Date: Mon, 19 Mar 2012 00:55:14 -0400

> On Thu, Mar 15, 2012 at 05:07:30PM -0700, Joe Perches wrote:
>> Use a more current logging style.
> 
> Oh, just for yucks, I did a quick check:
> 
> % git grep printk | wc -l
> 71266
> % git grep pr_ | wc -l
> 29552

It's up to 30,000 exactly because of the hard work of people like Joe
converting the tree over gradually.

If people like you keep resisting these kinds of changes, we'll
never get the whole tree using these nice new shorthands.
