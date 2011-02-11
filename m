Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704Ab1BKO0k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 09:26:40 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39787 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756394Ab1BKO0j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 09:26:39 -0500
Date: Fri, 11 Feb 2011 15:26:38 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] MAINTAINERS: add second list for IRDA
Message-ID: <20110211142638.GE2264@pengutronix.de>
References: <1296508906-14644-1-git-send-email-w.sang@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1296508906-14644-1-git-send-email-w.sang@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 10:21:46PM +0100, Wolfram Sang wrote:
> The irda-users-list is currently almost dead and subscribers-only. Adding
> netdev increases the audience which might help to not overlook a bugreport
> again.
> 
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> Acked-by: Samuel Ortiz <samuel@sortiz.org>
> ---
> 
> It would be easier for Samuel if it went via trivial.

Ping. Or is trivial not apropriate?

> 
>  MAINTAINERS |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 9d12977..4ff8659 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3420,6 +3420,7 @@ F:	net/ipx/
>  IRDA SUBSYSTEM
>  M:	Samuel Ortiz <samuel@sortiz.org>
>  L:	irda-users@lists.sourceforge.net (subscribers-only)
> +L:	netdev@vger.kernel.org
>  W:	http://irda.sourceforge.net/
>  S:	Maintained
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/sameo/irda-2.6.git
> -- 
> 1.7.2.3
> 

-- 
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
