Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510Ab1FTUGC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 16:06:02 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:40371 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195Ab1FTUGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 16:06:00 -0400
Date: Mon, 20 Jun 2011 13:05:15 -0700 (PDT)
Message-Id: <20110620.130515.1956879930278498236.davem@davemloft.net>
To: jj@chaosbits.net
Cc: netdev@vger.kernel.org, segoon@openwall.com, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Subject: Re: [PATCH][Trivial]: ipv4, ping: Remove duplicate icmp.h include
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LNX.2.00.1106201028340.18991@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1106201028340.18991@swampdragon.chaosbits.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 20 Jun 2011 13:05:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Juhl <jj@chaosbits.net>
Date: Mon, 20 Jun 2011 10:31:20 +0200 (CEST)

> Remove the duplicate inclusion of net/icmp.h from net/ipv4/ping.c
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Applied.
