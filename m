Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946340Ab2EKWYJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 18:24:09 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:37352 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946204Ab2EKWYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 18:24:07 -0400
Date: Fri, 11 May 2012 18:23:51 -0400 (EDT)
Message-Id: <20120511.182351.1369330702016518524.davem@davemloft.net>
To: sboyd@codeaurora.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, ben-linux@fluff.org
Subject: Re: [PATCH] ks8851: Update link status during link change interrupt
From: David Miller <davem@davemloft.net>
In-Reply-To: <1336690290-21304-1-git-send-email-sboyd@codeaurora.org>
References: <1336690290-21304-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 11 May 2012 15:23:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Boyd <sboyd@codeaurora.org>
Date: Thu, 10 May 2012 15:51:30 -0700

> If a link change interrupt comes in we just clear the interrupt
> and continue along without notifying the upper networking layers
> that the link has changed. Use the mii_check_link() function to
> update the link status whenever a link change interrupt occurs.
> 
> Cc: Ben Dooks <ben-linux@fluff.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Applied, thanks.
