Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964993Ab2CAVcM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 16:32:12 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:47168 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932672Ab2CAVcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 16:32:10 -0500
Date: Thu, 01 Mar 2012 16:28:37 -0500 (EST)
Message-Id: <20120301.162837.1843924175078247309.davem@davemloft.net>
To: b.van.den.berg.nl@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, srk@ti.com,
        vinay.hegde@ti.com, cyril@ti.com, richard.cochran@omicron.at,
        Julia.Lawall@lip6.fr, s.hauer@pengutronix.de, joe@perches.com
Subject: Re: [PATCH] davinci_emac: fixed setting MAC at init time
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120301084239.GA17146@altenpts-laptop>
References: <20120301084239.GA17146@altenpts-laptop>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 01 Mar 2012 13:28:41 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bas van den Berg <b.van.den.berg.nl@gmail.com>
Date: Thu, 1 Mar 2012 09:42:42 +0100

> Without this patch, the MAC number will show up as zero's until the interface
> is brought up for the first time. (eg. with ifconfig -a)
> 
> Signed-off-by: Bas van den Berg <b.van.den.berg.nl@gmail.com>

Well then the copy (which is also unnecessarily by hand using a loop
instead of a memcpy call) in emac_dev_open() is redundant and should
be removed when you make this change.
