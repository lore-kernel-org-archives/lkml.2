Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052Ab0IURil (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 13:38:41 -0400
Received: from cantor.suse.de ([195.135.220.2]:37926 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753013Ab0IURik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 13:38:40 -0400
Date: Tue, 21 Sep 2010 10:37:19 -0700
From: Greg KH <gregkh@suse.de>
To: Anca Emanuel <anca.emanuel@gmail.com>
Cc: "Savoy, Pavan" <pavan_savoy@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] drivers:staging:ti-st: remove st_get_plat_device
Message-ID: <20100921173719.GA11404@suse.de>
References: <19F8576C6E063C45BE387C64729E7394046836CB57@dbde02.ent.ti.com>
 <20100831041114.GA16009@suse.de>
 <19F8576C6E063C45BE387C64729E7394046836CE5C@dbde02.ent.ti.com>
 <20100831224238.GA13253@suse.de>
 <19F8576C6E063C45BE387C64729E739404687B2835@dbde02.ent.ti.com>
 <AANLkTimCkTFfe157dHK=caAdAeX_4m1A_p6ZRxp=2RWt@mail.gmail.com>
 <19F8576C6E063C45BE387C64729E739404687B2B27@dbde02.ent.ti.com>
 <AANLkTimZ2Pe5T2=ZUZnd_3-RQi8Qs4FrykkJy6Zvx89M@mail.gmail.com>
 <19F8576C6E063C45BE387C64729E739404687B2B81@dbde02.ent.ti.com>
 <AANLkTim0Z7AWeqCM4d26Z1UP1VsEaSBgqDCAUr1vqgMj@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTim0Z7AWeqCM4d26Z1UP1VsEaSBgqDCAUr1vqgMj@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 21, 2010 at 08:34:51PM +0300, Anca Emanuel wrote:
> > It is currently in linux-next.
> [...]
> >> >> Build error (kernel 2.6.36-rc3-git1):
> >> >>
> >> >>
> >> >> Building modules, stage 2.
> >> >>   MODPOST 3056 modules
> >> >> ERROR: "st_get_plat_device" [drivers/staging/ti-st/st_drv.ko] undefined!
> 
> Greg,
> 
> you send some pull requests to Linus.
> Can you compile the kernel without this patch ?

It works here for me, doesn't it for you?

> see here:
> http://kernel.ubuntu.com/~kernel-ppa/mainline/v2.6.36-rc5-maverick/0002-DISABLE-ti-st.patch
> 
> I know you are overburned. Just get 1 or 2 guys to teach them to help you.

I still don't understand, what does that patch have to do with the
staging tree?

thanks,

greg k-h
