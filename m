Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722Ab2GHXQS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 19:16:18 -0400
Received: from 1010ds2-suoe.0.fullrate.dk ([90.184.90.115]:27213 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237Ab2GHXQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 19:16:17 -0400
Date: Mon, 9 Jul 2012 01:16:15 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Joe Perches <joe@perches.com>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org,
        Marcos Paulo de Souza <marcos.mage@gmail.com>,
        Forest Bond <forest@alittletooquiet.net>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] staging: vt6656: iwctl: remove a few remaining
 redundant newlines
In-Reply-To: <1341788740.13174.33.camel@joe2Laptop>
Message-ID: <alpine.LNX.2.00.1207090113590.15263@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1206272116490.6908@swampdragon.chaosbits.net>  <20120706230945.GA8835@kroah.com>  <alpine.LNX.2.00.1207070228340.13344@swampdragon.chaosbits.net>  <alpine.LNX.2.00.1207090052220.15263@swampdragon.chaosbits.net> 
 <alpine.LNX.2.00.1207090056180.15263@swampdragon.chaosbits.net> <1341788740.13174.33.camel@joe2Laptop>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Jul 2012, Joe Perches wrote:

> On Mon, 2012-07-09 at 00:59 +0200, Jesper Juhl wrote:
> > I missed a few redundant newlines the first time.
> []
> > diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
> []
> > @@ -964,7 +964,6 @@ int iwctl_giwrts(struct net_device *dev, struct iw_request_info *info,
> >  	wrq->value = pDevice->wRTSThreshold;
> >  	wrq->disabled = (wrq->value >= 2312);
> >  	wrq->fixed = 1;
> > -
> >  	return 0;
> >  }
> 
> I think this is a useful style and these should not be removed.
> It's akin to a blank line after automatic variable declarations.
> 
Thank you for your feedback Joe.

I see your point, but personally I'd rather leave it out - especially for 
small functions.

I'll leave it up to Greg whether or not to take this one :-)


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

