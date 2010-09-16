Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091Ab0IPULT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 16:11:19 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:52277 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070Ab0IPULS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 16:11:18 -0400
Date: Thu, 16 Sep 2010 14:11:14 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Cc: christophe leroy <christophe.leroy@c-s.fr>,
        David Brownell <dbrownell@users.sourceforge.net>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH] spi_mpc8xxx: fix writing to adress 0
Message-ID: <20100916201114.GA11972@angua.secretlab.ca>
References: <20100916070420.95083C7391@messagerie.si.c-s.fr>
 <OFE491C952.64B1BE24-ONC12577A0.0029DACE-C12577A0.002A0993@transmode.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OFE491C952.64B1BE24-ONC12577A0.0029DACE-C12577A0.002A0993@transmode.se>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 16, 2010 at 09:39:09AM +0200, Joakim Tjernlund wrote:
> > From: christophe leroy <christophe.leroy@c-s.fr>
> > To: David Brownell <dbrownell@users.sourceforge.net>, Grant Likely
> > <grant.likely@secretlab.ca>, spi-devel-general@lists.sourceforge.net, linux-
> > kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
> > Date: 2010/09/16 09:06
> > Subject: [PATCH] spi_mpc8xxx: fix writing to adress 0
> > Sent by: linuxppc-dev-bounces+joakim.tjernlund=transmode.se@lists.ozlabs.org
> >
> > This patch applies to 2.6.34.7 (already included in 2.6.35.4)
> > It fixes an issue when sending only or receiving only (mspi->tx-dma was reset
> > as when no tx_buf is defined, tx_dma is 0)
> >
> > Signed-off-by: christophe leroy <christophe.leroy@c-s.fr>
> 
> Acked-by: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
> 

You need to send this to the linux-stable list and include the sha1
commit id that fixes it in mainline.

Acked-by: Grant Likely <grant.likely@secretlab.ca>

g.
