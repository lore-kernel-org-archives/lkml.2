Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911Ab1LARlZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 12:41:25 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:36253 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755746Ab1LARlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 12:41:24 -0500
Date: Thu, 01 Dec 2011 12:41:19 -0500 (EST)
Message-Id: <20111201.124119.485939880534098580.davem@davemloft.net>
To: axel.lin@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] dsa: Include linux/if_ether.h to fix build error
From: David Miller <davem@davemloft.net>
In-Reply-To: <1322726838.14554.3.camel@phoenix>
References: <1322726838.14554.3.camel@phoenix>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 01 Dec 2011 09:41:22 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Axel Lin <axel.lin@gmail.com>
Date: Thu, 01 Dec 2011 16:07:18 +0800

> Include linux/if_ether.h to fix below build errors:
> 
>   CC      arch/arm/mach-kirkwood/common.o
> In file included from arch/arm/mach-kirkwood/common.c:19:
> include/net/dsa.h: In function 'dsa_uses_dsa_tags':
> include/net/dsa.h:192: error: 'ETH_P_DSA' undeclared (first use in this function)
> include/net/dsa.h:192: error: (Each undeclared identifier is reported only once
> include/net/dsa.h:192: error: for each function it appears in.)
> include/net/dsa.h: In function 'dsa_uses_trailer_tags':
> include/net/dsa.h:197: error: 'ETH_P_TRAILER' undeclared (first use in this function)
> make[1]: *** [arch/arm/mach-kirkwood/common.o] Error 1
> make: *** [arch/arm/mach-kirkwood] Error 2
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied.
