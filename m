Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518Ab1JJTIT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 15:08:19 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47220 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540Ab1JJTIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 15:08:18 -0400
Date: Mon, 10 Oct 2011 23:08:12 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCHv5 16/19] power_supply: Convert all users to new usb_phy
Message-ID: <20111010190812.GA12821@oksana.dev.rtsoft.ru>
References: <1317036092-3000-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1317036092-3000-17-git-send-email-heikki.krogerus@linux.intel.com>
 <20111003131055.GC2487@xps8300>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20111003131055.GC2487@xps8300>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 04:10:55PM +0300, Heikki Krogerus wrote:
[...]
> > +static inline int
> > +isp1704_read(struct isp1704_charger *isp, u32 reg)

Cosmetic nitpick: I don't see any reason to break this into two lines.

> > +{
> > +	return usb_phy_io_read(isp->xceiv, reg);
> > +}
> > +
> > +static inline int
> > +isp1704_write(struct isp1704_charger *isp, u32 val, u32 reg)

Same here.

I assume you want this patch to go via some other tree, so feel
free to add

Acked-by: Anton Vorontsov <cbouatmailru@gmail.com>

Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
