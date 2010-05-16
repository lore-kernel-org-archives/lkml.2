Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357Ab0EPSTF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 14:19:05 -0400
Received: from mout6.freenet.de ([195.4.92.96]:36225 "EHLO mout6.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752744Ab0EPSTD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 14:19:03 -0400
From: Sascha Sommer <saschasommer@freenet.de>
To: Matt Fleming <matt@console-pimps.org>
Subject: Re: [PATCH] mmc: drop the "state" argument to mmc_suspend_host()
Date: Sun, 16 May 2010 20:20:18 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.31.12-0.2-default; KDE/4.3.5; i686; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
       Nicolas Ferre <nicolas.ferre@atmel.com>,
       Manuel Lauss <manuel.lauss@gmail.com>, Cliff Cai <cliff.cai@analog.com>,
       =?utf-8?q?Micha=C5=82_Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
       Pavel Pisa <ppisa@pikron.com>, David Brown <davidb@codeaurora.org>,
       Daniel Walker <dwalker@codeaurora.org>,
       Bryan Huntsman <bryanh@codeaurora.org>,
       Jarkko Lavinen <jarkko.lavinen@nokia.com>,
       Madhusudhan Chikkature <madhu.cr@ti.com>,
       Ben Dooks <ben-linux@fluff.org>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Alex Dubov <oakad@yahoo.com>, Ian Molton <ian@mnementh.co.uk>,
       Joseph Chan <JosephChan@via.com.tw>,
       Harald Welte <HaraldWelte@viatech.com>,
       Pierre Ossman <pierre@ossman.eu>
References: <d071c94414fc069d9360ae62a37fd2ad0b68110f.1273777159.git.matt@console-pimps.org>
In-Reply-To: <d071c94414fc069d9360ae62a37fd2ad0b68110f.1273777159.git.matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201005162020.18511.saschasommer@freenet.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Am Donnerstag 13 Mai 2010 21:01:45 schrieb Matt Fleming:
> Even though many mmc host drivers pass a pm_message_t argument to
> mmc_suspend_host() that argument isn't used the by MMC core. As host
> drivers are converted to dev_pm_ops they'll have to construct
> pm_message_t's (as they won't be passed by the PM subsystem any more)
> just to appease the mmc suspend interface.
> 
> We might as well just delete the unused paramter.
> 
> Signed-off-by: Matt Fleming <matt@console-pimps.org>

Acked-by: Sascha Sommer <saschasommer@freenet.de>

(for sdricoh_cs)

Regards

Sascha

