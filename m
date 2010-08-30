Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274Ab0H3UvV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 16:51:21 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56030
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753809Ab0H3UvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 16:51:19 -0400
Date: Mon, 30 Aug 2010 13:51:36 -0700 (PDT)
Message-Id: <20100830.135136.98876124.davem@davemloft.net>
To: geert@linux-m68k.org
Cc: netdev@vger.kernel.org, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/m68k: Hydra Ethernet - print whole resource
 instead of start address
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.DEB.2.00.1008300942560.30729@ayla.of.borg>
References: <alpine.DEB.2.00.1008300942560.30729@ayla.of.borg>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 30 Aug 2010 09:43:46 +0200 (CEST)

> resource_size_t changed from `unsigned long' to `phys_addr_t`, which is either
> `u32' or `u64'.
> Print the whole resource to remove the cast and to make it future-proof.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Applied to net-next-2.6, thanks!
