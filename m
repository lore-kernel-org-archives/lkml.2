Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758376Ab2JYHYr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 03:24:47 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:33176 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755115Ab2JYHYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 03:24:46 -0400
Date: Thu, 25 Oct 2012 03:24:42 -0400 (EDT)
Message-Id: <20121025.032442.2136601106266101183.davem@davemloft.net>
To: Claudio.Fontana@huawei.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/ipv4/ipconfig: add device address to a KERN_INFO
 message
From: David Miller <davem@davemloft.net>
In-Reply-To: <5088E6AD.2040302@huawei.com>
References: <5088E6AD.2040302@huawei.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Claudio Fontana <Claudio.Fontana@huawei.com>
Date: Thu, 25 Oct 2012 09:13:49 +0200

> -	pr_info("     device=%s, addr=%pI4, mask=%pI4, gw=%pI4\n",
> -		ic_dev->name, &ic_myaddr, &ic_netmask, &ic_gateway);
> +
> + pr_info(" device=%s, hwaddr=%*phC, ipaddr=%pI4, mask=%pI4,
> gw=%pI4\n",
> +		ic_dev->name, ic_dev->addr_len, ic_dev->dev_addr,
> +		&ic_myaddr, &ic_netmask, &ic_gateway);

Either you or your email client have destroyed the indentation
of these statements.
