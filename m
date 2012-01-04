Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757362Ab2ADXJd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 18:09:33 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:35127 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757332Ab2ADXJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 18:09:28 -0500
X-Sasl-enc: TpGwElEtIzRpJ9+nQea2MUtb+W1tkFaHOgvGslDh31I/ 1325718567
Date: Wed, 4 Jan 2012 15:08:56 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kay Sievers <kay.sievers@vrfy.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: linux-next: manual merge of the driver-core tree with Linus' tree
Message-ID: <20120104230856.GI24583@kroah.com>
References: <20111228162859.50b53b23e90ccf0145f2945a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111228162859.50b53b23e90ccf0145f2945a@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 28, 2011 at 04:28:59PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the driver-core tree got a conflict in
> arch/arm/mach-s3c64xx/s3c6400.c between commit 71b33a4f7c86 ("ARM:
> S3C64XX: Staticise s3c6400_sysclass") from Linus' tree and commit
> 4a858cfc9af8 ("arm: convert sysdev_class to a regular subsystem") from
> the driver-core tree.
> 
> The latter subsumed the change in the former, so I used that.

That sounds correct, thanks.

greg k-h
