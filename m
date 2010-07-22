Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760027Ab0GVSsn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 14:48:43 -0400
Received: from kroah.org ([198.145.64.141]:60755 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760001Ab0GVSsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 14:48:30 -0400
Date: Thu, 22 Jul 2010 11:45:57 -0700
From: Greg KH <greg@kroah.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Kulikov Vasiliy <segooon@gmail.com>, kernel-janitors@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Javier Martinez Canillas <martinez.javier@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Alexander Kurz <linux@kbdbabel.org>
Subject: Re: [PATCH 09/11] staging: comedi: formatting of pointers in
 printk()
Message-ID: <20100722184557.GC32116@kroah.com>
References: <1279176172-5609-1-git-send-email-segooon@gmail.com>
 <4C3EAEC5.8080908@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C3EAEC5.8080908@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 15, 2010 at 08:46:29AM +0200, Jiri Slaby wrote:
> On 07/15/2010 08:42 AM, Kulikov Vasiliy wrote:
> > Use %p instead of %08x in printk().
> > 
> > Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
> > ---
> >  drivers/staging/comedi/drivers/quatech_daqp_cs.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/staging/comedi/drivers/quatech_daqp_cs.c b/drivers/staging/comedi/drivers/quatech_daqp_cs.c
> > index 8d16380..8b49cb1 100644
> > --- a/drivers/staging/comedi/drivers/quatech_daqp_cs.c
> > +++ b/drivers/staging/comedi/drivers/quatech_daqp_cs.c
> > @@ -208,7 +208,7 @@ static void hex_dump(char *str, void *ptr, int len)
> 
> The name and parameters suggest to remove the function completely. (And
> use print_hex_dump_bytes instead.)

I agree, Kulikov, can you make that chagne instead?

thanks,

greg k-h
