Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758Ab1CPLhC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 07:37:02 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48661 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530Ab1CPLg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 07:36:56 -0400
Subject: Re: [PATCH] regulator: switch the ab3100 to use enable_time()
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Mattias Wallin <mattias.wallin@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>
In-Reply-To: <AANLkTi=W980GYHVxdYPV3xNKcdGpjAewKssoUc3ZoEDi@mail.gmail.com>
References: <1299857178-5221-1-git-send-email-linus.walleij@stericsson.com>
	 <20110311153134.GO1760@opensource.wolfsonmicro.com>
	 <AANLkTinD9fO9Tyft0CQABMea2SbcHexNmYT9_ND_Yb-M@mail.gmail.com>
	 <20110314181531.GA32434@opensource.wolfsonmicro.com>
	 <AANLkTi=W980GYHVxdYPV3xNKcdGpjAewKssoUc3ZoEDi@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Mar 2011 11:36:52 +0000
Message-ID: <1300275412.3432.46.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-15 at 10:07 +0100, Linus Walleij wrote:
> On Mon, Mar 14, 2011 at 7:15 PM, Mark Brown
> <broonie@opensource.wolfsonmicro.com> wrote:
> > On Mon, Mar 14, 2011 at 05:42:28PM +0100, Linus Walleij wrote:
> >
> >> Mark can you pick this into the regulator tree? I have sent my ux500
> >> tree upstream.
> >
> > No, I can't do that - mostly because Liam manages the regulator tree and
> > not me :)
> 
> Ah yeah now I remember. Liam, please?
> 

Now done. Sorry very busy atm.

Btw, you have a few other regulator patches recently in amongst MFD and
ARM updates. I assume these will go via MFD ?

Thanks

Liam

