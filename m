Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741Ab2GHXTN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 19:19:13 -0400
Received: from 1010ds2-suoe.0.fullrate.dk ([90.184.90.115]:33681 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390Ab2GHXTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 19:19:10 -0400
Date: Mon, 9 Jul 2012 01:19:09 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Joe Perches <joe@perches.com>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org,
        Marcos Paulo de Souza <marcos.mage@gmail.com>,
        Forest Bond <forest@alittletooquiet.net>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] staging: vt6656: iwctl: fix up spacing around
 operators
In-Reply-To: <1341788626.13174.31.camel@joe2Laptop>
Message-ID: <alpine.LNX.2.00.1207090116210.15263@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1206272116490.6908@swampdragon.chaosbits.net>  <20120706230945.GA8835@kroah.com>  <alpine.LNX.2.00.1207070228340.13344@swampdragon.chaosbits.net>  <alpine.LNX.2.00.1207090052220.15263@swampdragon.chaosbits.net> 
 <alpine.LNX.2.00.1207090054270.15263@swampdragon.chaosbits.net> <1341788626.13174.31.camel@joe2Laptop>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Jul 2012, Joe Perches wrote:

> On Mon, 2012-07-09 at 00:58 +0200, Jesper Juhl wrote:
> > A few cases were missed in my previous cleanup, this takes care of the
> > last cases of missing space (or too much space (as in a newline))
> > around operators ('=', '==', ',', '<').
> 
> Trivia:
> 
> > diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
> []
> > @@ -1624,8 +1624,7 @@ int iwctl_siwmlme(struct net_device *dev, struct iw_request_info *info,
> >  	case IW_MLME_DISASSOC:
> >  		if (pDevice->bLinkPass == TRUE) {
> >  			PRINT_K("iwctl_siwmlme--->send DISASSOCIATE\n");
> > -			bScheduleCommand((void *)pDevice,
> > -					WLAN_CMD_DISASSOCIATE,
> > +			bScheduleCommand((void *)pDevice, WLAN_CMD_DISASSOCIATE,
> >  					NULL);
> 
> pDevice doesn't need a cast.
> 
> bScheduleCommand uses a lot of casts for pDevice
> that aren't necessary.
> 
Right you are.

I have not gone through the file to verify all casts (yet). I was focused 
on getting it from the totally chaotic state it was in to something that 
was readable and reasonably close to CodingStyle. I'm well aware that it's 
not perfect (yet).

I'm a bit out of time right now and for the next couple of days, but I can 
probably do a review of the casts and send some follow-up patches later in 
the week.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

