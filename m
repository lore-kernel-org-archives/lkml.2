Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab1JSW7U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 18:59:20 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:35153 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753423Ab1JSW7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 18:59:19 -0400
Message-ID: <1319065158.27047.6.camel@Joe-Laptop>
Subject: Re: [patch net-next]alx: Atheros AR8131/AR8151/AR8152/AR8161
 Ethernet driver
From: Joe Perches <joe@perches.com>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: cloud.ren@atheros.com, davem@davemloft.net, Luis.Rodriguez@atheros.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 19 Oct 2011 15:59:18 -0700
In-Reply-To: <20111019222140.GA9937@electric-eye.fr.zoreil.com>
References: <1319009213-20627-1-git-send-email-cloud.ren@atheros.com>
	 <20111019222140.GA9937@electric-eye.fr.zoreil.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-10-20 at 00:21 +0200, Francois Romieu wrote:
> cloud.ren@atheros.com <cloud.ren@atheros.com> :
> > diff --git a/drivers/net/ethernet/atheros/alx/alc_cb.c b/drivers/net/ethernet/atheros/alx/alc_cb.c
> [...]

A bunch of good style comments.

> > +	hw->autoneg_advertised = (ALX_LINK_SPEED_1GB_FULL |
> > +				  ALX_LINK_SPEED_10_HALF  |
> > +				  ALX_LINK_SPEED_10_FULL  |
> > +				  ALX_LINK_SPEED_100_HALF |
> > +				  ALX_LINK_SPEED_100_FULL);
> Parenthesis abuse.

Maybe.  I use parenthesis too, but not the trailing | alignment.
emacs does leading alignment nicely when you use an open paren.


