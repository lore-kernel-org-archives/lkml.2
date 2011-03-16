Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078Ab1CPO0N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 10:26:13 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:32873 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034Ab1CPO0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 10:26:07 -0400
Subject: Re: [PATCH] regulator: switch the ab3100 to use enable_time()
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Mattias Wallin <mattias.wallin@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>
In-Reply-To: <AANLkTiks-D6QfoXmsJv_VPh-v4kZfjR29c6gpG5bW_vk@mail.gmail.com>
References: <1299857178-5221-1-git-send-email-linus.walleij@stericsson.com>
	 <20110311153134.GO1760@opensource.wolfsonmicro.com>
	 <AANLkTinD9fO9Tyft0CQABMea2SbcHexNmYT9_ND_Yb-M@mail.gmail.com>
	 <20110314181531.GA32434@opensource.wolfsonmicro.com>
	 <AANLkTi=W980GYHVxdYPV3xNKcdGpjAewKssoUc3ZoEDi@mail.gmail.com>
	 <1300275412.3432.46.camel@odin>
	 <AANLkTiks-D6QfoXmsJv_VPh-v4kZfjR29c6gpG5bW_vk@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Mar 2011 14:26:01 +0000
Message-ID: <1300285561.3432.47.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-16 at 13:43 +0100, Linus Walleij wrote:
> 2011/3/16 Liam Girdwood <lrg@slimlogic.co.uk>:
> 
> > Btw, you have a few other regulator patches recently in amongst MFD and
> > ARM updates. I assume these will go via MFD ?
> 
> The TPS6105x stuff will go through MFD, hopefully.
> 
> There are two other AB8500 regulator patches which are ripe
> for merge through the regulator tree right now, and that's the
> ones with Subjects:
> 
> "[PATCH 1/4] regulator: add support for USB voltage regulator"
> "[PATCH 3/4] regulator: initialization for ab8500 regulators"
> 
> Both have Mark's ACK, and I think they apply cleanly in
> that order. If there are any problems, tell me and I'll respin.
 
Both look fine and have been applied.

Thanks

Liam

