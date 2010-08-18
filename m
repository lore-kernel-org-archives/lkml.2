Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528Ab0HRJK3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 05:10:29 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50660 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab0HRJKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 05:10:15 -0400
Date: Wed, 18 Aug 2010 11:10:01 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        linux-mmc@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [PATCH] mmc: fix for CONFIG_PM disabled
Message-ID: <20100818091001.GA4805@pengutronix.de>
References: <201008112340.o7BNenDe021017@imap1.linux-foundation.org> <20100812093643.852adc98.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100812093643.852adc98.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 09:36:43AM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Minimal patch to fix mmc to build when CONFIG_PM is not enabled:
> 
> (.text+0x128fcd): undefined reference to `mmc_pm_notify'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

I sent the same patch[1] a few hours later than Randy, mine got

	Acked-by: Kukjin Kim <kgene.kim@samsung.com>
	Acked-by: Maxim Levitsky <maximlevitsky@gmail.com>

.  I think it's fine to add these to Randy's patch, too, together with
my Ack.  Maybe add a reference to the breaking commit as my patch did?
	
Thanks
Uwe

[1] http://mid.gmane.org/1281691473-15481-1-git-send-email-u.kleine-koenig@pengutronix.de

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
