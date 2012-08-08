Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757780Ab2HHWkx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 18:40:53 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:47132 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756859Ab2HHWkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 18:40:52 -0400
Date: Wed, 08 Aug 2012 15:40:43 -0700 (PDT)
Message-Id: <20120808.154043.2209307222855369747.davem@davemloft.net>
To: lliubbo@gmail.com
Cc: samuel@sortiz.org, rmk+kernel@arm.linux.org.uk, gregkh@linuxfoundation.org,
        kuninori.morimoto.gx@renesas.com, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org, netdev@vger.kernel.org,
        sonic.zhang@analog.com
Subject: Re: [RESEND][PATCH] drivers: net: irda: bfin_sir: fix compile error
From: David Miller <davem@davemloft.net>
In-Reply-To: <1344305316-23916-1-git-send-email-lliubbo@gmail.com>
References: <1344305316-23916-1-git-send-email-lliubbo@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Liu <lliubbo@gmail.com>
Date: Tue, 7 Aug 2012 10:08:36 +0800

> From: Sonic Zhang <sonic.zhang@analog.com>
> 
> Bit IREN is replaced by UMOD_IRDA and UMOD_MASK since blackfin 60x added, but
> this driver didn't update which will cause bfin_sir build error:
> 
> drivers/net/irda/bfin_sir.c:161:9: error: 'IREN' undeclared (first use in this
> function)
> drivers/net/irda/bfin_sir.c:435:18: error: 'IREN' undeclared (first use in
> this function)
> drivers/net/irda/bfin_sir.c:521:11: error: 'IREN' undeclared (first use in
> this function)
> 
> This patch fix it.
> 
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> Signed-off-by: Bob Liu <lliubbo@gmail.com>
> Acked-by: Samuel Ortiz <samuel@sortiz.org>

Applied, thanks.
