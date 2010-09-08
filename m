Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab0IHTF0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 15:05:26 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57406 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753135Ab0IHTFW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 15:05:22 -0400
From: "Savoy, Pavan" <pavan_savoy@ti.com>
To: Anca Emanuel <anca.emanuel@gmail.com>
CC: Greg KH <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 9 Sep 2010 00:35:07 +0530
Subject: RE: [PATCH] drivers:staging:ti-st: remove st_get_plat_device
Thread-Topic: [PATCH] drivers:staging:ti-st: remove st_get_plat_device
Thread-Index: ActPiIL58B802iPKTkSnnMbS+Pk0ZwAABWUA
Message-ID: <19F8576C6E063C45BE387C64729E739404687B2B81@dbde02.ent.ti.com>
References: <1282241331-5178-1-git-send-email-pavan_savoy@ti.com>
	<4C6D6A9A.3010409@oracle.com>
	<19F8576C6E063C45BE387C64729E7394044F124F7B@dbde02.ent.ti.com>
	<4C6D6BCB.2090307@oracle.com>
	<AANLkTi==HVhXcS0Mxv4GJL1rB0nLc3YQ=b5RbzM0iFwG@mail.gmail.com>
	<20100822033248.GA4886@suse.de>
	<19F8576C6E063C45BE387C64729E7394046836CB57@dbde02.ent.ti.com>
	<20100831041114.GA16009@suse.de>
	<19F8576C6E063C45BE387C64729E7394046836CE5C@dbde02.ent.ti.com>
	<20100831224238.GA13253@suse.de>
	<19F8576C6E063C45BE387C64729E739404687B2835@dbde02.ent.ti.com>
	<AANLkTimCkTFfe157dHK=caAdAeX_4m1A_p6ZRxp=2RWt@mail.gmail.com>
	<19F8576C6E063C45BE387C64729E739404687B2B27@dbde02.ent.ti.com>
 <AANLkTimZ2Pe5T2=ZUZnd_3-RQi8Qs4FrykkJy6Zvx89M@mail.gmail.com>
In-Reply-To: <AANLkTimZ2Pe5T2=ZUZnd_3-RQi8Qs4FrykkJy6Zvx89M@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Emanuel,
 

> -----Original Message-----
> From: Anca Emanuel [mailto:anca.emanuel@gmail.com]
> Sent: Wednesday, September 08, 2010 2:03 PM
> To: Savoy, Pavan
> Cc: Greg KH; linux-kernel@vger.kernel.org; devel@driverdev.osuosl.org; Linus
> Torvalds
> Subject: Re: [PATCH] drivers:staging:ti-st: remove st_get_plat_device
> 
> Linus, this patch is not in your tree.
> 
> please fix this.

I don't think it needs to be for now.
It will get merged upon next update from linux-next.

It is currently in linux-next.


> On Wed, Sep 8, 2010 at 5:39 PM, Savoy, Pavan <pavan_savoy@ti.com> wrote:
> > Emanuel,
> >
> > I've recently posted a patch to solve this problem.
> > Patch @ http://lkml.org/lkml/2010/8/19/238
> >
> > PS: In fact it is strange that you replied to the same thread which is
> supposed to solve the problem.
> >
> > Thanks...
> >
> >> -----Original Message-----
> >> From: Anca Emanuel [mailto:anca.emanuel@gmail.com]
> >> Sent: Wednesday, September 08, 2010 1:27 AM
> >> To: Savoy, Pavan
> >> Cc: Greg KH; linux-kernel@vger.kernel.org; devel@driverdev.osuosl.org
> >> Subject: Re: [PATCH] drivers:staging:ti-st: remove st_get_plat_device
> >>
> >> Build error (kernel 2.6.36-rc3-git1):
> >>
> >>
> >> Building modules, stage 2.
> >>   MODPOST 3056 modules
> >> ERROR: "st_get_plat_device" [drivers/staging/ti-st/st_drv.ko] undefined!
> >
