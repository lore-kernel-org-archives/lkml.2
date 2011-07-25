Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579Ab1GYXR7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 19:17:59 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:46684 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431Ab1GYXRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 19:17:45 -0400
Date: Mon, 25 Jul 2011 16:17:43 -0700 (PDT)
Message-Id: <20110725.161743.1867021302415399607.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: Convert struct net_device uc_promisc to
 bool
From: David Miller <davem@davemloft.net>
In-Reply-To: <813214b21d4db8d08a76c648ea1d3286b441b706.1311604594.git.joe@perches.com>
References: <813214b21d4db8d08a76c648ea1d3286b441b706.1311604594.git.joe@perches.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 25 Jul 2011 16:17:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Mon, 25 Jul 2011 07:41:26 -0700

> No need to use int, its uses are boolean.
> May save a few bytes one day.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
