Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289Ab2BDV1b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 16:27:31 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:36156 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171Ab2BDV1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 16:27:30 -0500
Date: Sat, 04 Feb 2012 16:27:25 -0500 (EST)
Message-Id: <20120204.162725.795698356179812016.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] tms380tr: Fix cascading if/else tab abuse
From: David Miller <davem@davemloft.net>
In-Reply-To: <1328388776.7008.13.camel@joe2Laptop>
References: <1328388776.7008.13.camel@joe2Laptop>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sat, 04 Feb 2012 13:27:26 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Sat, 04 Feb 2012 12:52:56 -0800

> Cascading "if/else if"'s are ugly.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
