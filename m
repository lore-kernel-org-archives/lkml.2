Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346Ab0HXTVG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 15:21:06 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42614
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752434Ab0HXTVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 15:21:04 -0400
Date: Tue, 24 Aug 2010 12:21:21 -0700 (PDT)
Message-Id: <20100824.122121.104040542.davem@davemloft.net>
To: heiko.carstens@de.ibm.com
Cc: sjur.brandeland@stericsson.com, schwidefsky@de.ibm.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] caif-driver: add HAS_DMA dependency
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100824151427.GC2160@osiris.boeblingen.de.ibm.com>
References: <20100824151427.GC2160@osiris.boeblingen.de.ibm.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>
Date: Tue, 24 Aug 2010 17:14:27 +0200

> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> Fix this error on an s390 allyesconfig build:
> 
> linux-2.6/drivers/net/caif/caif_spi.c:98:
>     undefined reference to `dma_free_coherent'
> 
> Cc: Sjur Braendeland <sjur.brandeland@stericsson.com>
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>

Applied, thanks.
