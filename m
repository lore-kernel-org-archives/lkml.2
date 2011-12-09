Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800Ab1LIA4a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 19:56:30 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:35711 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716Ab1LIA41 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 19:56:27 -0500
Date: Thu, 08 Dec 2011 19:54:39 -0500 (EST)
Message-Id: <20111208.195439.1316777589309191623.davem@davemloft.net>
To: LW@KARO-electronics.de
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, shawn.guo@linaro.org
Subject: Re: [PATCH v3 0/8] net/fec: several cleanups and bugfixes
From: David Miller <davem@davemloft.net>
In-Reply-To: <cover.1323326019.git.LW@KARO-electronics.de>
References: <cover.1323326019.git.LW@KARO-electronics.de>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 08 Dec 2011 16:54:42 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lothar Waﬂmann <LW@KARO-electronics.de>
Date: Thu,  8 Dec 2011 08:59:24 +0100

> The following set of patches provides some cleanup and bugfixes for
> drivers/net/ethernet/freescale/fec.c and makes the driver buildable as
> a module.
> 
> Changes wrt v2:
>  - subject prefix changed to be in sync with existing commits
>  - added Acked-by:

All applied.
