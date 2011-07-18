Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642Ab1GRRpr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 13:45:47 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:43567 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495Ab1GRRpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 13:45:46 -0400
Date: Mon, 18 Jul 2011 10:45:37 -0700 (PDT)
Message-Id: <20110718.104537.546991191560526229.davem@davemloft.net>
To: joe@perches.com
Cc: jdelvare@suse.de, grundler@parisc-linux.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tulip: dmfe: Remove old log spamming pr_debugs
From: David Miller <davem@davemloft.net>
In-Reply-To: <0a5f6c4c4c948dd5ff827bb5c5517294c9410bfc.1311000440.git.joe@perches.com>
References: <201107181440.35886.jdelvare@suse.de>
	<0a5f6c4c4c948dd5ff827bb5c5517294c9410bfc.1311000440.git.joe@perches.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 18 Jul 2011 10:45:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Mon, 18 Jul 2011 07:50:33 -0700

> Commit 726b65ad444d ("tulip: Convert uses of KERN_DEBUG") enabled
> some old previously inactive uses of pr_debug converted by
> commit dde7c8ef1679 ("tulip/dmfe.c: Use dev_<level> and pr_<level>").
> 
> Remove these pr_debugs.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
