Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702Ab0LWTDU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 14:03:20 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55345 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465Ab0LWTDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 14:03:19 -0500
Date: Thu, 23 Dec 2010 12:03:15 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Richard Genoud <richard.genoud@gmail.com>,
        spi-devel-general@lists.sourceforge.net,
        David Brownell <dbrownell@users.sourceforge.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] spi_imx.c: TRIVIAL mx25 & mx35 SPI_VER is 0.7
Message-ID: <20101223190315.GD20384@angua.secretlab.ca>
References: <1293102730-32528-1-git-send-email-richard.genoud@gmail.com>
 <1293102730-32528-2-git-send-email-richard.genoud@gmail.com>
 <20101223142934.GU14221@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101223142934.GU14221@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 23, 2010 at 03:29:34PM +0100, Uwe Kleine-König wrote:
> On Thu, Dec 23, 2010 at 12:12:10PM +0100, Richard Genoud wrote:
> > The check on cpu_is_mx25 and cpu_is_mx35 was made twice.
> > This is obviously wrong.
> obviously wrong but no wrong behaviour.  Your patch only makes the code
> consistent, but IMHO it doesn't qualify as a bugfix.
> 
> > Anyway, this patch won't change the previous behaviour which is
> > SPI_IMX_VER_0_7 for mx25 and mx35.
> This conflicts with
> http://mid.gmane.org/1290589546-21662-1-git-send-email-u.kleine-koenig@pengutronix.de
> 
> which I prefer.  The platform IDs have it correct (i.e.
> 
> 	imx25-cspi -> 0.7
> 	imx31-cspi -> 0.4
> 	imx35-cspi -> 0.7
> 
> )

Oops, missed you're reply.  Okay, I've dropped Richard's patch and will look at yours.


g.

