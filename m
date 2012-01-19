Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756392Ab2ASCBp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 21:01:45 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:42589 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab2ASCBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 21:01:44 -0500
Date: Wed, 18 Jan 2012 21:01:37 -0500 (EST)
Message-Id: <20120118.210137.1078675837531902060.davem@davemloft.net>
To: thfabba@gmx.de
Cc: ratbert@faraday-tech.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ftgmac100/ftmac100: add missing interrupt.h
 include
From: David Miller <davem@davemloft.net>
In-Reply-To: <4F1759A8.5080209@gmx.de>
References: <4F1759A8.5080209@gmx.de>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 18 Jan 2012 18:01:39 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Faber <thfabba@gmx.de>
Date: Thu, 19 Jan 2012 00:45:44 +0100

> Fixes compilation failure of these modules due to missing
> irqreturn_t type for the ft(g)mac100_interrupt definition.
> 
> Signed-off-by: Thomas Faber <thfabba@gmx.de>

Applied, thanks.
