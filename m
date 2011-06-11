Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568Ab1FKWvE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 18:51:04 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:59111 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905Ab1FKWvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 18:51:01 -0400
Date: Sat, 11 Jun 2011 15:50:52 -0700 (PDT)
Message-Id: <20110611.155052.13030300060739570.davem@davemloft.net>
To: ratbert.chuang@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, ratbert@faraday-tech.com
Subject: Re: [PATCH v3] net: add Faraday FTGMAC100 Gigabit Ethernet driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <1307611968-1595-1-git-send-email-ratbert.chuang@gmail.com>
References: <1300355238-1619-1-git-send-email-ratbert.chuang@gmail.com>
	<1307611968-1595-1-git-send-email-ratbert.chuang@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sat, 11 Jun 2011 15:50:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Po-Yu Chuang <ratbert.chuang@gmail.com>
Date: Thu,  9 Jun 2011 17:32:48 +0800

> From: Po-Yu Chuang <ratbert@faraday-tech.com>
> 
> FTGMAC100 Ethernet Media Access Controller supports 10/100/1000 Mbps
> and MII/GMII.  This driver has been working on some ARM/NDS32 SoC's
> including Faraday A369 and Andes AG102.
> 
> Signed-off-by: Po-Yu Chuang <ratbert@faraday-tech.com>

Applied to net-next-2.6, thanks.
