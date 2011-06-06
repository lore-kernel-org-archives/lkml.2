Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246Ab1FFADK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 20:03:10 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:53811 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634Ab1FFADH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 20:03:07 -0400
Date: Sun, 05 Jun 2011 17:03:01 -0700 (PDT)
Message-Id: <20110605.170301.571912692972468276.davem@davemloft.net>
To: grant.likely@secretlab.ca
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, thomas@wytron.com.tw
Subject: Re: [PATCH] net: fix smc91x.c device tree support
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110604073127.27163.47519.stgit@ponder>
References: <20110604073127.27163.47519.stgit@ponder>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 05 Jun 2011 17:03:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>
Date: Sat, 04 Jun 2011 01:31:27 -0600

> Fix missing semicolon at end of smc91x.c match tabledevice driver.
> Also remove unnecessary #ifdef around of_match_table pointer.
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>

Applied, thanks Grant.
