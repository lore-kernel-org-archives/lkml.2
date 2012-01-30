Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab2A3B2l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 20:28:41 -0500
Received: from mail2.nsc.com ([12.238.8.132]:46240 "EHLO sc-mailgw05.nsc.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752368Ab2A3B2e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 20:28:34 -0500
X-WSS-ID: 0LYL83J-0A-0NI-02
X-M-MSG: 
X-Server-Uuid: 75984BC7-5B1D-45FA-89A9-3E7188D47FBE
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
cc: "Anton Vorontsov" <cbouatmailru@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sun, 29 Jan 2012 17:28:25 -0800
Subject: RE: [PATCH 1/6] lp8727_charger: change description about
 company
Thread-Topic: [PATCH 1/6] lp8727_charger: change description about
 company
Thread-Index: Aczc6JN9oJtUwrJBRIag29KIlphk9wCBV0Sw
Message-ID: <B567DBAB974C0544994013492B949F8E3812D6EFC0@EXMAIL03.scwf.nsc.com>
References: <B567DBAB974C0544994013492B949F8E3812D6EB06@EXMAIL03.scwf.nsc.com>
 <20120127114235.36b985cd@pyramind.ukuu.org.uk>
In-Reply-To: <20120127114235.36b985cd@pyramind.ukuu.org.uk>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
MIME-Version: 1.0
X-WSS-ID: 633B2DBD1LS10007918-04-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Alan Cox [mailto:alan@lxorguk.ukuu.org.uk]
> Sent: Friday, January 27, 2012 8:43 PM
> To: Kim, Milo
> Cc: Anton Vorontsov; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 1/6] lp8727_charger: change description about
> company
> 
> On Thu, 26 Jan 2012 22:58:15 -0800
> "Kim, Milo" <Milo.Kim@ti.com> wrote:
> 
> > TI acquired National semiconductor at 2011.
> > : National semiconductor -> Texas Instruments
> >
> > Add driver information in the header file.
> >
> > Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
> > ---
> >  drivers/power/lp8727_charger.c |    4 ++--
> >  include/linux/lp8727.h         |    4 +++-
> >  2 files changed, 5 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/power/lp8727_charger.c
> b/drivers/power/lp8727_charger.c
> > index b15b575..97be22e 100755
> > --- a/drivers/power/lp8727_charger.c
> > +++ b/drivers/power/lp8727_charger.c
> > @@ -1,7 +1,7 @@
> >  /*
> >   * Driver for LP8727 Micro/Mini USB IC with intergrated charger
> >   *
> > - *			Copyright (C) 2011 National Semiconductor
> > + *			Copyright (C) 2011 Texas Instruments
> >   *
> >   * This program is free software; you can redistribute it and/or
> modify
> >   * it under the terms of the GNU General Public License version 2 as
> > @@ -488,7 +488,7 @@ static void __exit lp8727_exit(void)
> >  module_init(lp8727_init);
> >  module_exit(lp8727_exit);
> >
> > -MODULE_DESCRIPTION("National Semiconductor LP8727 charger driver");
> > +MODULE_DESCRIPTION("Texas Instruments LP8727 charger driver");
> 
> This may confuse people into thinking only the current TI branded
> version
> works ? I wonder if it should give both names ?

OK, adding new company name is better. New patch has been sent.
Please refer to ' [PATCH v2] lp8727_charger: add company name and description'.
Thank you.

Best Regards,
Milo -


