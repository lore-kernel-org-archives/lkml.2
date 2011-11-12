Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263Ab1KLXOc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Nov 2011 18:14:32 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:54321 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266Ab1KLXO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Nov 2011 18:14:26 -0500
Date: Sat, 12 Nov 2011 18:14:22 -0500 (EST)
Message-Id: <20111112.181422.1840921776479927270.davem@davemloft.net>
To: nbowler@elliptictech.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ah: Don't return NET_XMIT_DROP on input.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1320951687-21491-1-git-send-email-nbowler@elliptictech.com>
References: <1320951687-21491-1-git-send-email-nbowler@elliptictech.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sat, 12 Nov 2011 15:14:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Bowler <nbowler@elliptictech.com>
Date: Thu, 10 Nov 2011 14:01:27 -0500

> When the ahash driver returns -EBUSY, AH4/6 input functions return
> NET_XMIT_DROP, presumably copied from the output code path.  But
> returning transmit codes on input doesn't make a lot of sense.
> Since NET_XMIT_DROP is a positive int, this gets interpreted as
> the next header type (i.e., success).  As that can only end badly,
> remove the check.
> 
> Signed-off-by: Nick Bowler <nbowler@elliptictech.com>

Applied and queued up for -stable, thanks Nick.
