Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964817Ab1LPU3r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 15:29:47 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:58363 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760558Ab1LPU3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 15:29:40 -0500
Date: Fri, 16 Dec 2011 15:27:26 -0500 (EST)
Message-Id: <20111216.152726.1312007167282874878.davem@davemloft.net>
To: joerg.roedel@amd.com
Cc: yevgenyp@mellanox.co.il, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sfr@canb.auug.org.au
Subject: Re: [PATCH] mlx4: Fix compile error when driver is comiled-in
From: David Miller <davem@davemloft.net>
In-Reply-To: <20111215164837.GE2112@amd.com>
References: <20111215164837.GE2112@amd.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 16 Dec 2011 12:27:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>
Date: Thu, 15 Dec 2011 17:48:37 +0100

> Testing my iommu-configs against linux-next found a compile error for
> allyesconfig. It only happens when the mlx4 driver is compiled into the
> kernel and not as a module because these two static functions are also
> used in another file. The attached patch fixes it.
> 
>>From b993c4448c2ce5447fd24e7d4fce02e633d3222e Mon Sep 17 00:00:00 2001
> From: Joerg Roedel <joerg.roedel@amd.com>
> Date: Thu, 15 Dec 2011 17:30:33 +0100
> Subject: [PATCH 1/2] mlx4: Fix compile error when driver is comiled-in
> 
> This patch fixes a compile error that occurs when the driver
> is compile into the kernel and not as a module.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>

I wish we detected "exporting symbol marked static" properly.

I'll apply this, thanks!
