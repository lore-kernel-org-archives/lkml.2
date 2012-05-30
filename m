Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385Ab2E3Cbp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 22:31:45 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:33542 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756338Ab2E3Cbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 22:31:44 -0400
Date: Tue, 29 May 2012 22:31:39 -0400 (EDT)
Message-Id: <20120529.223139.1478035863626187036.davem@davemloft.net>
To: devendra.aaru@gmail.com
Cc: florian@openwrt.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 2/2] r6040: Do a Proper deinit at errorpath and also
 when driver unloads (calling r6040_remove_one)
From: David Miller <davem@davemloft.net>
In-Reply-To: <1338335014-14877-1-git-send-email-devendra.aaru@gmail.com>
References: <1338335014-14877-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 29 May 2012 19:31:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Devendra Naga <devendra.aaru@gmail.com>
Date: Wed, 30 May 2012 05:13:34 +0530

> so if mdiobus_alloc fails, the errorpath doesnt do a netif_napi_del and also
> doesn't set the priv data of the driver to NULL.
> 
> at the driver unload stage the driver doesn't remove the NAPI context, and
> doesnt' set the priv data to NULL, and also doesn't call the pci_iounmap.
> 
> Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>

Applied.
