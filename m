Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758954Ab0EMVmM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 17:42:12 -0400
Received: from rere.qmqm.pl ([89.167.52.164]:33478 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757445Ab0EMVmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 17:42:09 -0400
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 May 2010 17:42:09 EDT
Date: Thu, 13 May 2010 23:35:29 +0200
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To: Matt Fleming <matt@console-pimps.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
       Nicolas Ferre <nicolas.ferre@atmel.com>,
       Manuel Lauss <manuel.lauss@gmail.com>, Cliff Cai <cliff.cai@analog.com>,
       Pavel Pisa <ppisa@pikron.com>, David Brown <davidb@codeaurora.org>,
       Daniel Walker <dwalker@codeaurora.org>,
       Bryan Huntsman <bryanh@codeaurora.org>,
       Jarkko Lavinen <jarkko.lavinen@nokia.com>,
       Madhusudhan Chikkature <madhu.cr@ti.com>,
       Ben Dooks <ben-linux@fluff.org>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Sascha Sommer <saschasommer@freenet.de>, Alex Dubov <oakad@yahoo.com>,
       Ian Molton <ian@mnementh.co.uk>, Joseph Chan <JosephChan@via.com.tw>,
       Harald Welte <HaraldWelte@viatech.com>,
       Pierre Ossman <pierre@ossman.eu>
Subject: Re: [PATCH] mmc: drop the "state" argument to mmc_suspend_host()
Message-ID: <20100513213529.GA26715@rere.qmqm.pl>
References: <d071c94414fc069d9360ae62a37fd2ad0b68110f.1273777159.git.matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d071c94414fc069d9360ae62a37fd2ad0b68110f.1273777159.git.matt@console-pimps.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 08:01:45PM +0100, Matt Fleming wrote:
> Even though many mmc host drivers pass a pm_message_t argument to
> mmc_suspend_host() that argument isn't used the by MMC core. As host
> drivers are converted to dev_pm_ops they'll have to construct
> pm_message_t's (as they won't be passed by the PM subsystem any more)
> just to appease the mmc suspend interface.
> 
> We might as well just delete the unused paramter.
> 
> Signed-off-by: Matt Fleming <matt@console-pimps.org>

Acked-by: Micha³ Miros³aw <mirq-linux@rere.qmqm.pl>

(For cb710-mmc part.)

