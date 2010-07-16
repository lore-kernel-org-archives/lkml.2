Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935728Ab0GPHFt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 03:05:49 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57474 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935690Ab0GPHFq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 03:05:46 -0400
From: "Savoy, Pavan" <pavan_savoy@ti.com>
To: Greg KH <gregkh@suse.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 16 Jul 2010 12:35:35 +0530
Subject: RE: [PATCH] drivers:staging:ti-st: make use of linux err codes
Thread-Topic: [PATCH] drivers:staging:ti-st: make use of linux err codes
Thread-Index: Acsksrx6HNvYdYHeQwOkIdz3fIG/NwAAl8tw
Message-ID: <19F8576C6E063C45BE387C64729E7394044EC82616@dbde02.ent.ti.com>
References: <AANLkTikrtkVSWZoyVL6A0Maa16cKxGUnnuyrRGmpU09z@mail.gmail.com>
 <662196.81557.qm@web94905.mail.in2.yahoo.com>
 <20100716064309.GA31418@suse.de>
In-Reply-To: <20100716064309.GA31418@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

> -----Original Message-----
> From: Greg KH [mailto:gregkh@suse.de]
> Sent: Friday, July 16, 2010 1:43 AM
> To: Savoy, Pavan
> Cc: linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] drivers:staging:ti-st: make use of linux err codes
> 
> On Fri, Jul 16, 2010 at 11:54:40AM +0530, Pavan Savoy wrote:
> >
> > --- On Fri, 16/7/10, Pavan Savoy <pavan.savoy@gmail.com> wrote:
> >
> > > From: Pavan Savoy <pavan.savoy@gmail.com>
> > > Subject: [PATCH] drivers:staging:ti-st: make use of linux err codes
> > > To: "pavan savoy" <pavan_savoy@yahoo.co.in>
> > > Date: Friday, 16 July, 2010, 11:52 AM
> > > ---------- Forwarded message
> > > ----------
> > > From:? <pavan_savoy@ti.com>
> > > Date: Wed, Jul 14, 2010 at 6:51 PM
> > > Subject: [PATCH] drivers:staging:ti-st: make use of linux
> > > err codes
> > > To: alan@lxorguk.ukuu.org.uk,
> > > gregkh@suse.de
> > > Cc: devel@driverdev.osuosl.org,
> > > linux-kernel@vger.kernel.org,
> >
> > Greg,
> > Any comments ? Is it good to go ?
> 
> I am currently travelling at a conference somewhere in Europe, and will
Oh cool.

> not be able to get back to applying patches until late next week, sorry.
> Don't worry, it's in my "to-apply" queue and is not lost.
Thanks.

> 
> thanks,
> 
> greg k-h
