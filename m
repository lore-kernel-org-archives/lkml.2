Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018Ab2BFTnI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 14:43:08 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:52877 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802Ab2BFTnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 14:43:07 -0500
Date: Mon, 06 Feb 2012 14:42:49 -0500 (EST)
Message-Id: <20120206.144249.2096673389778792309.davem@davemloft.net>
To: cascardo@linux.vnet.ibm.com
Cc: yevgenyp@mellanox.co.il, ogerlitz@mellanox.com, eugenia@mellanox.co.il,
        alexg@mellanox.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mlx4: allow device removal by fixing dma unmap size
From: David Miller <davem@davemloft.net>
In-Reply-To: <1328553590-27677-1-git-send-email-cascardo@linux.vnet.ibm.com>
References: <1328553590-27677-1-git-send-email-cascardo@linux.vnet.ibm.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 06 Feb 2012 11:42:54 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Date: Mon,  6 Feb 2012 16:39:49 -0200

> After opening the network interface, Mellanox ConnectX device cannot be
> removed by hotplug because it has not properly unmapped all DMA memory.
> 
> It happens that mlx4_en_activate_rx_rings overrides the variable that
> keeps the size of the memory mapped.
> 
> This is fixed by passing to mlx4_en_destroy_rx_ring the same size that is
> given to mlx4_en_create_rx_ring.
> 
> After applying this patch, hot unplugging the device works after opening
> the interface.
> 
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>

Applied.
