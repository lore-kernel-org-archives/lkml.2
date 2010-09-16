Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159Ab0IPHlu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 03:41:50 -0400
Received: from gw1.transmode.se ([213.115.205.20]:41094 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813Ab0IPHlt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 03:41:49 -0400
In-Reply-To: <20100916070420.95083C7391@messagerie.si.c-s.fr>
References: <20100916070420.95083C7391@messagerie.si.c-s.fr>
Subject: Re: [PATCH] spi_mpc8xxx: fix writing to adress 0
X-KeepSent: E491C952:64B1BE24-C12577A0:0029DACE;
 type=4; name=$KeepSent
To: christophe leroy <christophe.leroy@c-s.fr>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, spi-devel-general@lists.sourceforge.net
X-Mailer: Lotus Notes Release 8.5.2 August 10, 2010
Message-ID: <OFE491C952.64B1BE24-ONC12577A0.0029DACE-C12577A0.002A0993@transmode.se>
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Date: Thu, 16 Sep 2010 09:39:09 +0200
X-MIMETrack: Serialize by Router on sesr04/Transmode(Release 8.5.2 HF23|September 01, 2010) at
 2010-09-16 09:41:47
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: christophe leroy <christophe.leroy@c-s.fr>
> To: David Brownell <dbrownell@users.sourceforge.net>, Grant Likely
> <grant.likely@secretlab.ca>, spi-devel-general@lists.sourceforge.net, linux-
> kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
> Date: 2010/09/16 09:06
> Subject: [PATCH] spi_mpc8xxx: fix writing to adress 0
> Sent by: linuxppc-dev-bounces+joakim.tjernlund=transmode.se@lists.ozlabs.org
>
> This patch applies to 2.6.34.7 (already included in 2.6.35.4)
> It fixes an issue when sending only or receiving only (mspi->tx-dma was reset
> as when no tx_buf is defined, tx_dma is 0)
>
> Signed-off-by: christophe leroy <christophe.leroy@c-s.fr>

Acked-by: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>

