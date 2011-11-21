Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599Ab1KUUFe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 15:05:34 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:40381 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842Ab1KUUFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 15:05:32 -0500
Date: Mon, 21 Nov 2011 15:03:57 -0500 (EST)
Message-Id: <20111121.150357.2118454419753712021.davem@davemloft.net>
To: thomas@m3y3r.de
Cc: samuel@sortiz.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: Use kmemdup rather than duplicating its
 implementation
From: David Miller <davem@davemloft.net>
In-Reply-To: <1321569820.1624.307.camel@localhost.localdomain>
References: <1321569820.1624.307.camel@localhost.localdomain>
X-Mailer: Mew version 6.4 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 21 Nov 2011 12:03:59 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Meyer <thomas@m3y3r.de>
Date: Thu, 17 Nov 2011 23:43:40 +0100

> The semantic patch that makes this change is available
> in scripts/coccinelle/api/memdup.cocci.
> 
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>

Applied, with subject line fixed and "Dup" comment removed.
