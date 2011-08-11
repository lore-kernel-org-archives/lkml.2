Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671Ab1HKMzx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 08:55:53 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:36495 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153Ab1HKMzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 08:55:51 -0400
Date: Thu, 11 Aug 2011 05:53:33 -0700 (PDT)
Message-Id: <20110811.055333.1199553373699762518.davem@davemloft.net>
To: julia@diku.dk
Cc: bart.de.schuymer@pandora.be, kernel-janitors@vger.kernel.org,
        kaber@trash.net, shemminger@linux-foundation.org,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, bridge@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/bridge/netfilter/ebtables.c: use available error
 handling code
From: David Miller <davem@davemloft.net>
In-Reply-To: <1313063978-29400-1-git-send-email-julia@diku.dk>
References: <1313063978-29400-1-git-send-email-julia@diku.dk>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 11 Aug 2011 05:53:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Thu, 11 Aug 2011 13:59:38 +0200

> From: Julia Lawall <julia@diku.dk>
> 
> Free the locally allocated table and newinfo as done in adjacent error
> handling code.
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

Applied.
