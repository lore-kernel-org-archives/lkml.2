Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564Ab2DRXks (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 19:40:48 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:62353 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477Ab2DRXkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 19:40:46 -0400
Date: Wed, 18 Apr 2012 16:40:42 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Kyungmin Park <kyungmin.park@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        LKML <linux-kernel@vger.kernel.org>, NeilBrown <neilb@suse.de>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Mike Lockwood <lockwood@android.com>,
        Arve =?iso-8859-1?Q?Hj=F8nnevag?= <arve@android.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        John Stultz <john.stultz@linaro.org>,
        Joerg Roedel <joerg.roedel@amd.com>, myungjoo.ham@gmail.com,
        cw00.choi@samsung.com
Subject: Re: [PATCH v7 1/6] Extcon (external connector): import Android's
 switch class and modify.
Message-ID: <20120418234042.GB23221@kroah.com>
References: <1332492784-10526-1-git-send-email-myungjoo.ham@samsung.com>
 <1332492784-10526-2-git-send-email-myungjoo.ham@samsung.com>
 <20120418214703.GA31606@kroah.com>
 <CAH9JG2VRas6LWCZSF3BFEsJvOS+6AeYMe_BQh3H18kh_=8CNqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH9JG2VRas6LWCZSF3BFEsJvOS+6AeYMe_BQh3H18kh_=8CNqg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 08:38:06AM +0900, Kyungmin Park wrote:
> Hi Greg,
> 
> Can you check the latest extcon at here?
> 
> http://git.infradead.org/users/kmpark/linux-samsung/shortlog/refs/heads/extcon

No, please send me patches, that's what I need to have in order to apply
them.

Always make sure that your patches do not break the build along the
series, which is what happened here.  Did you not test this?

thanks,

greg k-h
