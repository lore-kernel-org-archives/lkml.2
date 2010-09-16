Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab0IPHlw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 03:41:52 -0400
Received: from gw1.transmode.se ([213.115.205.20]:41095 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456Ab0IPHlt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 03:41:49 -0400
In-Reply-To: <20100916070525.4882CC7391@messagerie.si.c-s.fr>
References: <20100916070525.4882CC7391@messagerie.si.c-s.fr>
Subject: Re: [PATCH] spi_mpc8xxx: fix buffer overrun when sending only/receiving
	only more than PAGE_SIZE bytes
X-KeepSent: D056F539:7143D21A-C12577A0:002A0D53;
 type=4; name=$KeepSent
To: christophe leroy <christophe.leroy@c-s.fr>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, spi-devel-general@lists.sourceforge.net
X-Mailer: Lotus Notes Release 8.5.2 August 10, 2010
Message-ID: <OFD056F539.7143D21A-ONC12577A0.002A0D53-C12577A0.002A26CB@transmode.se>
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Date: Thu, 16 Sep 2010 09:40:24 +0200
X-MIMETrack: Serialize by Router on sesr04/Transmode(Release 8.5.2 HF23|September 01, 2010) at
 2010-09-16 09:41:48
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: christophe leroy <christophe.leroy@c-s.fr>
> To: David Brownell <dbrownell@users.sourceforge.net>, Grant Likely
> <grant.likely@secretlab.ca>, spi-devel-general@lists.sourceforge.net, linux-
> kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
> Date: 2010/09/16 09:07
> Subject: [PATCH] spi_mpc8xxx: fix buffer overrun when sending only/receiving
> only more than PAGE_SIZE bytes
> Sent by: linuxppc-dev-bounces+joakim.tjernlund=transmode.se@lists.ozlabs.org
>
> This patch applies to 2.6.34.7 and 2.6.35.4
> It fixes an issue when sending only or receiving only more than PAGE_SIZE bytes
>
> Signed-off-by: christophe leroy <christophe.leroy@c-s.fr>

Acked-by: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>

