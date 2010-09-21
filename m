Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758194Ab0IUULx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 16:11:53 -0400
Received: from cantor.suse.de ([195.135.220.2]:43783 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755990Ab0IUULv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 16:11:51 -0400
Date: Tue, 21 Sep 2010 13:06:08 -0700
From: Greg KH <gregkh@suse.de>
To: "Savoy, Pavan" <pavan_savoy@ti.com>
Cc: Anca Emanuel <anca.emanuel@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] drivers:staging:ti-st: remove st_get_plat_device
Message-ID: <20100921200608.GA23089@suse.de>
References: <19F8576C6E063C45BE387C64729E739404687B2835@dbde02.ent.ti.com>
 <AANLkTimCkTFfe157dHK=caAdAeX_4m1A_p6ZRxp=2RWt@mail.gmail.com>
 <19F8576C6E063C45BE387C64729E739404687B2B27@dbde02.ent.ti.com>
 <AANLkTimZ2Pe5T2=ZUZnd_3-RQi8Qs4FrykkJy6Zvx89M@mail.gmail.com>
 <19F8576C6E063C45BE387C64729E739404687B2B81@dbde02.ent.ti.com>
 <AANLkTim0Z7AWeqCM4d26Z1UP1VsEaSBgqDCAUr1vqgMj@mail.gmail.com>
 <20100921173719.GA11404@suse.de>
 <AANLkTim1cjcXf+eB7O9cTfEu1s=+-eL3uZ=UcXvb8H4M@mail.gmail.com>
 <20100921181250.GA11157@suse.de>
 <19F8576C6E063C45BE387C64729E73940468A15F16@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19F8576C6E063C45BE387C64729E73940468A15F16@dbde02.ent.ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 21, 2010 at 11:48:58PM +0530, Savoy, Pavan wrote:
> 
> Emanuel,
>  
> > If so, which one is it?
> 
> This patch on the ti-st/ inside staging/ fixes the problem.
> It has made it to the linux-next,
> http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commit;h=dbd3a8709560365ff9b1e5eca263f608877a8a89

I'll add it to the queue to go to Linus earlier if I get the chance.  If
not, it's not a big deal we can add it to the .36-stable tree.

thanks,

greg k-h
