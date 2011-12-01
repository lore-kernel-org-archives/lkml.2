Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab1LASbU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 13:31:20 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:36712 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756142Ab1LASbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 13:31:18 -0500
Date: Thu, 01 Dec 2011 13:31:14 -0500 (EST)
Message-Id: <20111201.133114.1983782132846748196.davem@davemloft.net>
To: cmetcalf@tilera.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] drivers/net/ethernet/tile: use skb_frag_page() API
From: David Miller <davem@davemloft.net>
In-Reply-To: <201112011815.pB1IFD2t004910@farm-0002.internal.tilera.com>
References: <201112011815.pB1IFD2t004910@farm-0002.internal.tilera.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 01 Dec 2011 10:31:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 1 Dec 2011 12:56:03 -0500

> This replaces raw access to the "page" field of the skb_frag_t.
> 
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>

Please merge these changes via your Tile tree, you can add my:

Acked-by: David S. Miller <davem@davemloft.net>

Thanks.
