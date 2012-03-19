Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262Ab2CSU62 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 16:58:28 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:38887 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478Ab2CSU60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 16:58:26 -0400
Date: Mon, 19 Mar 2012 16:58:20 -0400 (EDT)
Message-Id: <20120319.165820.1896441211313260247.davem@davemloft.net>
To: joe@perches.com
Cc: linux-kernel@vger.kernel.org, jcliburn@gmail.com, chris.snook@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH 2/4] atlx: Use ETH_ALEN
From: David Miller <davem@davemloft.net>
In-Reply-To: <1670f6450b7624f8aa92ef2c08c6aa0d0e5d5ef9.1332128181.git.joe@perches.com>
References: <cover.1332128181.git.joe@perches.com>
	<1670f6450b7624f8aa92ef2c08c6aa0d0e5d5ef9.1332128181.git.joe@perches.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 19 Mar 2012 13:58:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Sun, 18 Mar 2012 20:37:57 -0700

> No need for yet another #define for this.
> 
> Convert NODE_ADDRESS_SIZE use to ETH_ALEN and remove #define.
> Use memcpy instead of a loop to copy an address.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
