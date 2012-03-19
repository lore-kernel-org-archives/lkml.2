Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114Ab2CSFM0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 01:12:26 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:56830 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964Ab2CSFMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 01:12:25 -0400
Date: Mon, 19 Mar 2012 01:12:11 -0400 (EDT)
Message-Id: <20120319.011211.89954160788757412.davem@davemloft.net>
To: tytso@mit.edu
Cc: joe@perches.com, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/9] ext4: Use pr_fmt and pr_<level>
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120319043420.GL31682@thunk.org>
References: <20120319040950.GG31682@thunk.org>
	<20120319.001430.1735750114727679638.davem@davemloft.net>
	<20120319043420.GL31682@thunk.org>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 18 Mar 2012 22:12:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ted Ts'o" <tytso@mit.edu>
Date: Mon, 19 Mar 2012 00:34:20 -0400

> Things like printk(KERN_INFO, ...) are quite well established, and
> changing really doesn't add any value.

It also allows you to modify pr_fmt at the top of the file or
elsewhere and have it influence the output, as just one example
of how it's better.

As a maintainer you can only take one of two positions:

1) Accept all properly written patches that convert code over to use
   the new and recommended way of doing things, such as pr_info() et
   al.

2) Advocate on linux-kernel to remove these new interfaces or improve
   them if you don't find them suitable, and then once suitable go
   back to #1.

Just keeping things the way they are because you simply feel like it
is really not acceptable Ted.
