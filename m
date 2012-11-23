Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408Ab2KWTVR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 14:21:17 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:49480 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787Ab2KWTVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 14:21:16 -0500
Date: Fri, 23 Nov 2012 14:21:10 -0500 (EST)
Message-Id: <20121123.142110.835354734152648777.davem@davemloft.net>
To: andreas@gaisler.com
Cc: sam@ravnborg.org, rob.herring@calxeda.com, grant.likely@secretlab.ca,
        sparclinux@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, software@gaisler.com
Subject: Re: [PATCH] of/address: sparc: Declare of_iomap as an extern
 function for sparc again
From: David Miller <davem@davemloft.net>
In-Reply-To: <1353669849-23697-1-git-send-email-andreas@gaisler.com>
References: <1353669849-23697-1-git-send-email-andreas@gaisler.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Larsson <andreas@gaisler.com>
Date: Fri, 23 Nov 2012 12:24:09 +0100

> This bug-fix makes sure that of_iomap is defined extern for sparc so that the
> sparc-specific implementation of_iomap is once again used when including
> include/linux/of_address.h in a sparc context. OF_GPIO that is now available for
> sparc relies on this.
> 
> The bug was inadvertently introduced in a850a75, "of/address: add empty static
> inlines for !CONFIG_OF", that added a static dummy inline for of_iomap when
> !CONFIG_OF_ADDRESS. However, CONFIG_OF_ADDRESS is never defined for sparc, but
> there is a sparc-specific implementation /arch/sparc/kernel/of_device_common.c.
> 
> This fix takes the same approach as 0bce04b that solved the equivalent problem
> for of_address_to_resource.
> 
> Signed-off-by: Andreas Larsson <andreas@gaisler.com>

Grant, can you possibly merge this to Linus while I'm travelling?
That would help me a lot.

Thanks!
