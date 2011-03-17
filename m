Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708Ab1CQIt0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 04:49:26 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60115 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021Ab1CQItX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 04:49:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=JZGPxhSeZu6J6vO32Q/32ahRoeHXvPPZo/DizUBVvYVhGEmxszX1xs72IeVFOpl/dx
         pSk0C6q/xuT2gBZ39Y1v5wTNq/3ofpW/UKPu6E0ywRSQcY8E+WC5UHfa33s++/8L1GmH
         X+ZYxZFCk66nCMDfYBS2R007GKFGOMEEeSys4=
MIME-Version: 1.0
In-Reply-To: <20110316125052.GB8369@sirena.org.uk>
References: <1299857178-5221-1-git-send-email-linus.walleij@stericsson.com>
	<20110311153134.GO1760@opensource.wolfsonmicro.com>
	<AANLkTinD9fO9Tyft0CQABMea2SbcHexNmYT9_ND_Yb-M@mail.gmail.com>
	<20110314181531.GA32434@opensource.wolfsonmicro.com>
	<AANLkTi=W980GYHVxdYPV3xNKcdGpjAewKssoUc3ZoEDi@mail.gmail.com>
	<1300275412.3432.46.camel@odin>
	<AANLkTiks-D6QfoXmsJv_VPh-v4kZfjR29c6gpG5bW_vk@mail.gmail.com>
	<20110316125052.GB8369@sirena.org.uk>
Date: Thu, 17 Mar 2011 09:49:23 +0100
X-Google-Sender-Auth: 4RuqXn-OzIEmKpENuKsPEi2t30w
Message-ID: <AANLkTin7iZ6B2d=PfangmOLOrSgPSjxrAm5drP0fOfyA@mail.gmail.com>
Subject: Re: [PATCH] regulator: switch the ab3100 to use enable_time()
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Mattias Wallin <mattias.wallin@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/3/16 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Wed, Mar 16, 2011 at 01:43:25PM +0100, Linus Walleij wrote:
>> 2011/3/16 Liam Girdwood <lrg@slimlogic.co.uk>:
>
>> > Btw, you have a few other regulator patches recently in amongst MFD and
>> > ARM updates. I assume these will go via MFD ?
>
>> The TPS6105x stuff will go through MFD, hopefully.
>
> Note that this isn't 100% required for new drivers - since you have a
> dependency on the MFD you can merge subdevices through their own trees
> and they won't cause problems as they can't be built until the MFD is
> merged and makes the core symbol available.

Yep that's true in general, in this case the regulator driver is
extending a header file provided by the MFD core, so they need
to be kept in succession...

Linus Walleij
