Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492Ab0F3TPM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 15:15:12 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:41484 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401Ab0F3TPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 15:15:10 -0400
Subject: Re: pull request: wireless-2.6 2010-06-30
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20100630.120551.170116973.davem@davemloft.net>
References: <20100630185319.GA2618@tuxdriver.com>
	 <20100630.120551.170116973.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Jun 2010 21:15:04 +0200
Message-ID: <1277925304.7823.16.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-30 at 12:05 -0700, David Miller wrote:

> > +	/*
> > +	 * Receiving all multicast frames is always enabled by the
> > +	 * default flags setup in iwl_connection_init_rx_config()
> > +	 * since we currently do not support programming multicast
> > +	 * filters into the device.
> > +	 */
> >  	*total_flags &= FIF_OTHER_BSS | FIF_ALLMULTI | FIF_PROMISC_IN_BSS |
> >  			FIF_BCN_PRBRESP_PROMISC | FIF_CONTROL;
> 
> Note that this is an amazingly serious limitation.
> 
> This basically makes iwl chips unsuitable for use on networks where
> real multicast use is common.

Lots of wireless devices have this limitation unfortunately. I think we
-might- be able to have proper filters for iwl, but haven't found out
quite how yet unfortunately, if it's actually implemented properly on
the device and there's not just some fake API.

johannes

