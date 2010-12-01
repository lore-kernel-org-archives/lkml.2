Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200Ab0LASvN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 13:51:13 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49207 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755259Ab0LASvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 13:51:11 -0500
Date: Wed, 1 Dec 2010 19:51:03 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Hans Ulli Kroll <ulli.kroll@googlemail.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] Kconfig: add new symbol MIGHT_HAVE_PCI
Message-ID: <20101201185103.GK32355@pengutronix.de>
References: <1291217412-9435-1-git-send-email-ulli.kroll@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1291217412-9435-1-git-send-email-ulli.kroll@googlemail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 01, 2010 at 04:30:12PM +0100, Hans Ulli Kroll wrote:
> Today more boards with arm cpu have selectable pci bus.
> This patch makes this more scalable and remove line continuations in
> Kconfig
> 
> Cc: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Hans Ulli Kroll <ulli.kroll@googlemail.com>
> ---
>  arch/arm/Kconfig                 |    7 ++++++-
>  arch/arm/mach-cns3xxx/Kconfig    |    1 +
>  arch/arm/mach-integrator/Kconfig |    1 +
>  arch/arm/mach-ks8695/Kconfig     |    1 +
>  arch/arm/mach-pxa/Kconfig        |    1 +
>  arch/arm/mach-versatile/Kconfig  |    1 +
>  6 files changed, 11 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index a19a526..614cf2f 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -34,6 +34,9 @@ config ARM
>  config HAVE_PWM
>  	bool
>  
> +config MIGHT_HAVE_PCI
HAVE_PCI or HAS_PCI is a more usual name for this purpose.

Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
