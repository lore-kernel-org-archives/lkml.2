Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932285Ab2BATwZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 14:52:25 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:33778 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756774Ab2BATnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 14:43:09 -0500
Date: Wed, 01 Feb 2012 14:43:05 -0500 (EST)
Message-Id: <20120201.144305.251984620339115457.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: dev: Convert printks to pr_<level>
From: David Miller <davem@davemloft.net>
In-Reply-To: <1328125229.18641.17.camel@joe2Laptop>
References: <1327882830.2652.16.camel@joe2Laptop>
	<20120201.142156.871464551711177387.davem@davemloft.net>
	<1328125229.18641.17.camel@joe2Laptop>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 01 Feb 2012 11:43:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Wed, 01 Feb 2012 11:40:29 -0800

> Do you prefer coalesced formats in all cases?
> 
> 		pr_warn("Number of in use tx queues changed invalidating tc mappings. Priority traffic classification disabled!\n");

It seems to be the new trend, so yes.
