Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792Ab2EXEb7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 00:31:59 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:36579 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216Ab2EXEb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 00:31:58 -0400
Date: Thu, 24 May 2012 00:31:48 -0400 (EDT)
Message-Id: <20120524.003148.700603156196416506.davem@davemloft.net>
To: cmetcalf@tilera.com
Cc: bhutchings@solarflare.com, arnd@arndb.de, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v7] tilegx network driver: initial support
From: David Miller <davem@davemloft.net>
In-Reply-To: <201205240115.q4O1FwqG006336@lab-41.internal.tilera.com>
References: <201205201636.q4KGaoA3003845@farm-0027.internal.tilera.com>
	<20120520.165546.1211013675964130504.davem@davemloft.net>
	<201205240115.q4O1FwqG006336@lab-41.internal.tilera.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 23 May 2012 21:31:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Metcalf <cmetcalf@tilera.com>
Date: Wed, 23 May 2012 16:42:03 -0400

> + * FIXME (bug 11489): add support for IPv6.
 ...
> +	 * FIXME (bug# 11479): We should stop queues when they're full.
 ...

Mentioning bug numbers in the driver source is not appropriate.

This second problem looks extremely serious, rather than some minor
issue to look into at some time in the future.
