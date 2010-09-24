Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998Ab0IXHZv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 03:25:51 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42857 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab0IXHZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 03:25:50 -0400
Date: Fri, 24 Sep 2010 09:25:44 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linus Walleij <linus.ml.walleij@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: Re: [PATCH 1/3] dmaengine: add possibility for cyclic transfers
Message-ID: <20100924072544.GN23406@pengutronix.de>
References: <1281956870-12463-1-git-send-email-s.hauer@pengutronix.de> <1281956870-12463-2-git-send-email-s.hauer@pengutronix.de> <20100920130119.GA23406@pengutronix.de> <AANLkTi=B1ZkoYZ3hjuzz8Uj=W-04cE+iedaMwurUMRPy@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=B1ZkoYZ3hjuzz8Uj=W-04cE+iedaMwurUMRPy@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:25:28 up 82 days, 22:36, 23 users,  load average: 0.59, 0.68,
	0.94
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 23, 2010 at 12:42:20PM -0700, Dan Williams wrote:
> On Mon, Sep 20, 2010 at 6:01 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> > Hi Dan,
> >
> > Any comment to this patch?
> 
> Looks good to me especially given the unique implications for
> callbacks.  Although, I'd like to put a description of the
> prep_dma_cyclic semantics in the source code.  Can you respin this
> with a description added to the kernel-doc for struct dma_device?

Sure, will do.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
