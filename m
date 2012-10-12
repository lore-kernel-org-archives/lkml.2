Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab2JLWE3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 18:04:29 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:55455 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172Ab2JLWE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 18:04:28 -0400
Message-ID: <1350079465.9386.6.camel@trivette.mtl.sfl>
Subject: Re: [PATCH] gpio: add TS-5500 DIO headers support
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Jerome Oufella <jerome.oufella@savoirfairelinux.com>
Date: Fri, 12 Oct 2012 18:04:25 -0400
In-Reply-To: <CACRpkdbbungMiZ74o=-CfRoLQj127CaWaYr7adKKSquFd=x5qg@mail.gmail.com>
References: <1348620130-25987-1-git-send-email-vivien.didelot@savoirfairelinux.com>
	 <CACRpkdaaD6HY2o-NNBRZYCXm97Dts7Njzz13Zj7m2ZycV-Ar5g@mail.gmail.com>
	 <1349720405.23690.45.camel@trivette>
	 <CACRpkdbbungMiZ74o=-CfRoLQj127CaWaYr7adKKSquFd=x5qg@mail.gmail.com>
Organization: Savoir-faire Linux Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Fri, 2012-10-12 at 22:53 +0200, Linus Walleij wrote:
> Well that may also be a pretty big step if you just want to mux
> one bank of GPIO. I'm a bit ambivalent. But if you want to tie
> pin and gpio information together and name all pins, pinctrl
> is what should suit you best.
> 
> In the GPIO world, things are opaque "gpios" not really pins. 

Thanks a lot for all your comments. I think I'll stick with the GPIO
framework for the moment, trying to keep it as simple as possible.

About the generic driver (to allow registering one platform device per
DIO block), I think it won't be possible, because there are shared
regions, such as 0x7d, used by DIO2 and LCD DIO for direction...

Is there a way to share this, or does this mean that this driver should
handle the 3 blocks as it already does?

Thanks,
Vivien

