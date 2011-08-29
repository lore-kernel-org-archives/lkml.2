Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889Ab1H2TeF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 15:34:05 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:58399 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754797Ab1H2TeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 15:34:02 -0400
X-Sasl-enc: ogkxU9zjAYLZFJ8CbLli3Cm3inblrl94PH2lKO2LVTob 1314646441
Date: Mon, 29 Aug 2011 12:33:44 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?iso-8859-1?Q?=22Uwe_Kleine-K=F6nig=22?= 
	<u.kleine-koenig@pengutronix.de>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: linux-next: manual merge of the driver-core tree with the
 arm-soc tree
Message-ID: <20110829193344.GA13418@kroah.com>
References: <20110829143150.78ade5470cf62a83ad9b56f1@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110829143150.78ade5470cf62a83ad9b56f1@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 02:31:50PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the driver-core tree got a conflict in
> arch/arm/plat-mxc/devices.c between commit 160a84cfc975 ("ARM: mxc: drop
> now unused function mxc_register_device") from the arm-soc tree and
> commit 0e392412f334 ("ARM: mxc: convert device creation to use
> platform_device_register_full") from the driver-core tree.
> 
> Just context changes.  I fixed it up (see below) anc can carry the fix as
> necessary.

Thanks, that looks fine.

greg k-h
