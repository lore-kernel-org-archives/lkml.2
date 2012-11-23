Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258Ab2KWTah (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 14:30:37 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:49582 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754097Ab2KWTag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 14:30:36 -0500
Date: Fri, 23 Nov 2012 14:30:33 -0500 (EST)
Message-Id: <20121123.143033.141910826801165909.davem@davemloft.net>
To: nicolas.ferre@atmel.com
Cc: netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, manabian@gmail.com,
        plagnioj@jcrosoft.com
Subject: Re: [PATCH] net/macb: GEM DMA configuration register update
From: David Miller <davem@davemloft.net>
In-Reply-To: <1353678541-26839-1-git-send-email-nicolas.ferre@atmel.com>
References: <1353678541-26839-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Ferre <nicolas.ferre@atmel.com>
Date: Fri, 23 Nov 2012 14:49:01 +0100

> Add information to the DMA Configuration Register to
> maximize system performance:
> - rx/tx packet buffer full memory size
> - allow possibility to use INCR16 if supported
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Applied to net-next.
