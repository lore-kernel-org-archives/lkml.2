Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760244Ab2DKNhx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 09:37:53 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:54129 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755111Ab2DKNhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 09:37:51 -0400
Date: Wed, 11 Apr 2012 09:35:40 -0400 (EDT)
Message-Id: <20120411.093540.1313049193929998.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: grant.likely@secretlab.ca, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.abraham@linaro.org
Subject: Re: linux-next: build failure after merge of the final tree
 (devicetree tree related)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120411151155.b1a614f174442a592d1c1561@canb.auug.org.au>
References: <20120411151155.b1a614f174442a592d1c1561@canb.auug.org.au>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 11 Apr 2012 06:35:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 11 Apr 2012 15:11:55 +1000

> Hi all,
> 
> After merging the final tree, today's linux-next build (sparc64 defconfig)
> failed like this:
> 
> drivers/of/of_mdio.c: In function 'of_mdiobus_register':
> drivers/of/of_mdio.c:75:4: error: implicit declaration of function 'irq_of_parse_and_map' [-Werror=implicit-function-declaration]
> 
> Caused by commit e46c11b94787 ("of/irq: add empty irq_of_parse_and_map()
> for non-dt builds").  SPARC has CONFIG_OF but not CONFIG_OF_IRQ ...

If I had a nickel for every time an implicit dependency on CONFIG_OF_IRQ
was added to the tree... :-)
