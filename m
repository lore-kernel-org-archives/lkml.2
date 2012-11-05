Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932838Ab2KEPWb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 10:22:31 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:55774 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754413Ab2KEPWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 10:22:25 -0500
X-Sasl-enc: ZLgFLHkNX4Ee2ltLA1EUicbxjt9F7ye08sDzHqEcjRfr 1352128943
Date: Mon, 5 Nov 2012 16:22:31 +0100
From: Greg Kroah-Hartman <greg@kroah.com>
To: Joe Perches <joe@perches.com>
Cc: YAMANE Toshiaki <yamanetoshi@gmail.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging/media: Use dev_ printks in go7007/s2250-loader.c
Message-ID: <20121105152231.GA4807@kroah.com>
References: <1352115282-8081-1-git-send-email-yamanetoshi@gmail.com>
 <20121105131108.GC27238@kroah.com>
 <1352128271.16194.8.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352128271.16194.8.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2012 at 07:11:11AM -0800, Joe Perches wrote:
> On Mon, 2012-11-05 at 14:11 +0100, Greg Kroah-Hartman wrote:
> > On Mon, Nov 05, 2012 at 08:34:42PM +0900, YAMANE Toshiaki wrote:
> > > fixed below checkpatch warnings.
> > > - WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...
> > > - WARNING: Prefer netdev_info(netdev, ... then dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...
> > > 
> > > Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
> > > ---
> > >  drivers/staging/media/go7007/s2250-loader.c |   35 ++++++++++++++-------------
> > >  1 file changed, 18 insertions(+), 17 deletions(-)
> > 
> > Please note that I don't touch the drivers/staging/media/* files, so
> > copying me on these patches doesn't do anything :)
> 
> Maybe:
> 
>  MAINTAINERS |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index b062349..542a541 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6906,6 +6906,7 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
>  L:	devel@driverdev.osuosl.org
>  S:	Supported
>  F:	drivers/staging/
> +X:	drivers/staging/media/

Sure, that would be good, care to resend it with a signed-off-by: so I
can apply it?

thanks,

greg k-h
