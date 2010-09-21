Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134Ab0IUSTv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 14:19:51 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44303 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755543Ab0IUSTu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 14:19:50 -0400
From: "Savoy, Pavan" <pavan_savoy@ti.com>
To: Greg KH <gregkh@suse.de>, Anca Emanuel <anca.emanuel@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 21 Sep 2010 23:48:58 +0530
Subject: RE: [PATCH] drivers:staging:ti-st: remove st_get_plat_device
Thread-Topic: [PATCH] drivers:staging:ti-st: remove st_get_plat_device
Thread-Index: ActZuLBz/7dM4tAmSKS471CR3YpIAgAAEAEQ
Message-ID: <19F8576C6E063C45BE387C64729E73940468A15F16@dbde02.ent.ti.com>
References: <19F8576C6E063C45BE387C64729E7394046836CE5C@dbde02.ent.ti.com>
 <20100831224238.GA13253@suse.de>
 <19F8576C6E063C45BE387C64729E739404687B2835@dbde02.ent.ti.com>
 <AANLkTimCkTFfe157dHK=caAdAeX_4m1A_p6ZRxp=2RWt@mail.gmail.com>
 <19F8576C6E063C45BE387C64729E739404687B2B27@dbde02.ent.ti.com>
 <AANLkTimZ2Pe5T2=ZUZnd_3-RQi8Qs4FrykkJy6Zvx89M@mail.gmail.com>
 <19F8576C6E063C45BE387C64729E739404687B2B81@dbde02.ent.ti.com>
 <AANLkTim0Z7AWeqCM4d26Z1UP1VsEaSBgqDCAUr1vqgMj@mail.gmail.com>
 <20100921173719.GA11404@suse.de>
 <AANLkTim1cjcXf+eB7O9cTfEu1s=+-eL3uZ=UcXvb8H4M@mail.gmail.com>
 <20100921181250.GA11157@suse.de>
In-Reply-To: <20100921181250.GA11157@suse.de>
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


Emanuel,
 

> -----Original Message-----
> From: Greg KH [mailto:gregkh@suse.de]
> Sent: Tuesday, September 21, 2010 1:13 PM
> To: Anca Emanuel
> Cc: Savoy, Pavan; linux-kernel@vger.kernel.org; devel@driverdev.osuosl.org;
> Linus Torvalds
> Subject: Re: [PATCH] drivers:staging:ti-st: remove st_get_plat_device
> 
> On Tue, Sep 21, 2010 at 09:06:07PM +0300, Anca Emanuel wrote:
> > >> see here:
> > >> http://kernel.ubuntu.com/~kernel-ppa/mainline/v2.6.36-rc5-maverick/0002-
> DISABLE-ti-st.patch
> > >>
> > >> I know you are overburned. Just get 1 or 2 guys to teach them to help
> you.
> > >
> > > I still don't understand, what does that patch have to do with the
> > > staging tree?
> > >
> > > thanks,
> > >
> > > greg k-h
> > >
> >
> > In Ubuntu, the ti-st driver have a problem at the building time.
> 
> Ok, then in Ubuntu, don't enable it in the configuration file, no need
> to comment out the whole directory :)
> 
> Is there a specific patch that fixes this issue that is not around?  Or
> is it already in my staging-next tree and you feel it should be added to
> the final .36 release?
> 
> If so, which one is it?

This patch on the ti-st/ inside staging/ fixes the problem.
It has made it to the linux-next,
http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commit;h=dbd3a8709560365ff9b1e5eca263f608877a8a89


> thanks,
> 
> greg k-h
