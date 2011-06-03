Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239Ab1FCIPK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 04:15:10 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:57109 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab1FCIPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 04:15:07 -0400
Date: Fri, 03 Jun 2011 01:14:55 -0700 (PDT)
Message-Id: <20110603.011455.414200582548238157.davem@davemloft.net>
To: daniel@gaisler.com
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree
 (sparc-current tree related)
From: David Miller <davem@davemloft.net>
In-Reply-To: <4DE8906F.5040501@gaisler.com>
References: <20110603135347.a17e0b85.sfr@canb.auug.org.au>
	<20110602.222051.270790327969020201.davem@davemloft.net>
	<4DE8906F.5040501@gaisler.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 03 Jun 2011 01:14:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Hellstrom <daniel@gaisler.com>
Date: Fri, 03 Jun 2011 09:42:39 +0200

> missed that, PCIC_PCI should depend on SPARC32_PCI instead of PCI in
> the following lines that were added by the patch
> 
> +config PCIC_PCI
> +	bool
> +	depends on PCI && !SPARC_LEON
> +	default y
> +

The fixed I pushed out used PCI && SPARC32 && !SPARC_LEON
