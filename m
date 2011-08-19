Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605Ab1HSR2c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 13:28:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:25826 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756355Ab1HSR22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 13:28:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="39510496"
Subject: Re: [PATCH] DMAEngine: Define generic transfer request api
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: Linus Walleij <linus.ml.walleij@gmail.com>,
        "sundaram@ti.com" <sundaram@ti.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "rmk+kernel@arm.linux.org.uk" <rmk+kernel@arm.linux.org.uk>,
        "nsekhar@ti.com" <nsekhar@ti.com>
In-Reply-To: <CAJe_ZhfSsE40ucx5=f7bBJ5WXeWib=OdGRyFTA-3Di6i608EOw@mail.gmail.com>
References: <1313147667-3385-1-git-send-email-jaswinder.singh@linaro.org>
	 <1313499399.1603.92.camel@vkoul-udesk3>
	 <CACRpkdaY_wuz+zS-iKCPT-M7EpvtxCNX+OJ6NROSaQtZ6XoNMg@mail.gmail.com>
	 <1313761404.18591.1.camel@vkoul-udesk3>
	 <CAKnu2Mpu2H18=xF4OwmqSgML_dDa6SE7ZqHFjLb2GL_-Wabqsw@mail.gmail.com>
	 <CAJe_ZhfSsE40ucx5=f7bBJ5WXeWib=OdGRyFTA-3Di6i608EOw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Aug 2011 22:58:03 +0530
Message-ID: <1313774883.18591.11.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-19 at 21:16 +0530, Jassi Brar wrote:
> On 19 August 2011 19:49, Linus Walleij <linus.ml.walleij@gmail.com> wrote:
> > 2011/8/19 Koul, Vinod <vinod.koul@intel.com>:
> >> On Tue, 2011-08-16 at 15:06 +0200, Linus Walleij wrote:
> >>> On Tue, Aug 16, 2011 at 2:56 PM, Koul, Vinod <vinod.koul@intel.com> wrote:
> >
> >>> I think Sundaram is in the position of doing some heavy work on
> >>> using one or the other of the API:s, and I think he is better
> >>> suited than anyone else of us to select what scheme to use,
> >>> in the end he's going to write the first code using the API.
> >
> >> And Unfortunately TI folks don't seem to care about this discussion :(
> >> Haven't seen anything on this from them, or on previous RFC by Jassi
> >
> > Well if there is no code usig the API then there is no rush
> > in merging it either I guess. Whenever someone (TI or
> > Samsung) cook some driver patches they can choose their
> > approach.
> >
> No, it's not a matter of "choice".
> If that were the case, Sundaram already proposed a TI specific
> flag. Why wait for him to tell his choice again?
> 
> You might, but I can't molest my sensibility to believe that a Vendor
> specific flag could be better than a generic solution.
> Not here at least, where the overhead due to generality is not much.
> (though I can trim some 'futuristic' members from the 'struct xfer_template')
Who said anything about adding a vendor flag solution, since TI are
potential users of the API it would good to know i this fits there needs
are not. If they don't care, we can't help it...

> 
> Maintainers might wait as long as they want, but there should never
> be an option to have vendor specific hacks.
to me API looks decent after reading some specs of DMACs which support
this mode. Pls send updated patch along with one driver which uses it.
Should be good to go...


-- 
~Vinod

