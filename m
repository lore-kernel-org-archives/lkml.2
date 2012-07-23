Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890Ab2GWIsx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 04:48:53 -0400
Received: from 1010ds2-suoe.0.fullrate.dk ([90.184.90.115]:11750 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691Ab2GWIsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 04:48:52 -0400
Date: Mon, 23 Jul 2012 10:48:49 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Dan Carpenter <dan.carpenter@oracle.com>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org,
        Christopher Harrer <charrer@alacritech.com>,
        linux-kernel@vger.kernel.org, Lior Dotan <liodot@gmail.com>
Subject: Re: [PATCH 1/2] Staging: slicoss: Clean up tabs vs spaces in
 slic.h
In-Reply-To: <20120723070150.GA4352@mwanda>
Message-ID: <alpine.LNX.2.00.1207231047390.701@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1207222253370.31033@swampdragon.chaosbits.net> <20120723070150.GA4352@mwanda>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jul 2012, Dan Carpenter wrote:

> On Sun, Jul 22, 2012 at 10:57:09PM +0200, Jesper Juhl wrote:
> > Make it match CodingStyle a bit better, tab/space wise.
> > 
> > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> > ---
> >  drivers/staging/slicoss/slic.h | 751 ++++++++++++++++++++---------------------
> >  1 file changed, 374 insertions(+), 377 deletions(-)
> > 
> > diff --git a/drivers/staging/slicoss/slic.h b/drivers/staging/slicoss/slic.h
> > index ebdcc6f..0deb670 100644
> > --- a/drivers/staging/slicoss/slic.h
> > +++ b/drivers/staging/slicoss/slic.h
> > @@ -42,61 +42,62 @@
> >  #define __SLIC_DRIVER_H__
> >  
> >  /* firmware stuff */
> > -#define OASIS_UCODE_VERS_STRING	"1.2"
> > -#define OASIS_UCODE_VERS_DATE  	"2006/03/27 15:10:37"
> > -#define OASIS_UCODE_HOSTIF_ID  	3
> > +#define OASIS_UCODE_VERS_STRING "1.2"
> > +#define OASIS_UCODE_VERS_DATE "2006/03/27 15:10:37"
> > +#define OASIS_UCODE_HOSTIF_ID 3
> 
> No.  The original was far better.
> 
> Looking through the rest of the patch, some of these changes are ok,
> and some are nonsense.
> 
Ok, thank you for taking a look. I'll give this patch (as well as 2/2) a 
new look tonight and re-spin them and hopefully do better the second time 
around :-)

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

