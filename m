Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517Ab2GRSg2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 14:36:28 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37115 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755445Ab2GRSgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 14:36:23 -0400
Date: Wed, 18 Jul 2012 11:36:23 -0700 (PDT)
Message-Id: <20120718.113623.984635805289135415.davem@davemloft.net>
To: cmetcalf@tilera.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3 v2] net: various tilegx networking fixes
From: David Miller <davem@davemloft.net>
In-Reply-To: <201207181650.q6IGodZ7007565@lab-41.internal.tilera.com>
References: <201207181650.q6IGodZ7007565@lab-41.internal.tilera.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.97 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Metcalf <cmetcalf@tilera.com>
Date: Sun, 1 Jul 2012 14:43:47 -0400

> The tree is at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git net
> 
> Chris Metcalf (3):
>       net: tilegx driver bugfix (be explicit about percpu queue number)
>       tilegx net driver: handle payload data not in frags
>       tilegx net: use eth_hw_addr_random(), not random_ether_addr()

These changes look fine, but when I pull from your tree I get tons of
totally unrelated stuff and a merge conflict in this driver.

Can you put together a clean pull against net-next?

Thanks.
