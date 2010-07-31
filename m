Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212Ab0GaFJ4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 01:09:56 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38642
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751143Ab0GaFJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 01:09:54 -0400
Date: Fri, 30 Jul 2010 22:10:12 -0700 (PDT)
Message-Id: <20100730.221012.112594570.davem@davemloft.net>
To: randy.dunlap@oracle.com
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH -next] net: ks8842 depends on DMA_ENGINE
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100729101427.2aafd6e7.randy.dunlap@oracle.com>
References: <20100729143211.9e7edaed.sfr@canb.auug.org.au>
	<20100729101427.2aafd6e7.randy.dunlap@oracle.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Thu, 29 Jul 2010 10:14:27 -0700

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> ks8842 uses dma channel functions, so it should depend on DMA_ENGINE.
> 
> ERROR: "__dma_request_channel" [drivers/net/ks8842.ko] undefined!
> ERROR: "dma_release_channel" [drivers/net/ks8842.ko] undefined!
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Applied, thanks Randy.
