Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956Ab0HPExo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 00:53:44 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50690 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab0HPExn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 00:53:43 -0400
Date: Mon, 16 Aug 2010 06:53:40 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Igor Grinberg <grinberg@compulab.co.il>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, Sergei Shtylyov <sshtylyov@mvista.com>,
        Mike Rapoport <mike@compulab.co.il>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH v2] ARM: imx: fix build failure concerning otg/ulpi
Message-ID: <20100816045340.GA17038@pengutronix.de>
References: <4C65246E.1000906@ru.mvista.com> <1281701210-27776-1-git-send-email-u.kleine-koenig@pengutronix.de> <4C6783C7.1030604@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4C6783C7.1030604@compulab.co.il>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Igor,

On Sun, Aug 15, 2010 at 09:05:59AM +0300, Igor Grinberg wrote:
> On 08/13/10 15:06, Uwe Kleine-König wrote:
> > The build failure was introduced by
> >
> > 	13dd0c9 (USB: otg/ulpi: extend the generic ulpi driver.)
> >
> > Cc: Igor Grinberg <grinberg@compulab.co.il>
> > Cc: Mike Rapoport <mike@compulab.co.il>
> > Cc: Greg Kroah-Hartman <gregkh@suse.de>
> > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> >   
> 
> I've based my patches on v2.6.35-rc6, so I could not patch
> those imx variants, sorry...
> But I did deal with mach-pca100.c, so I think moving it from
> mach-mx2 to mach-imx is what made it miss my patch.
> 
> Anyway, this looks like the right addition.
I assume this is an Ack?

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
