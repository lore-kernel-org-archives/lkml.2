Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294Ab1HLVbO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 17:31:14 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:59591 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab1HLVbN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 17:31:13 -0400
From: "Nori, Sekhar" <nsekhar@ti.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Lee Jones <lee.jones@linaro.org>, "Hilman, Kevin" <khilman@ti.com>
Date: Sat, 13 Aug 2011 03:00:27 +0530
Subject: RE: [PATCH 08/19] mach-davinci: move DaVinci TNET GPIO driver to
 GPIO subsystem
Thread-Topic: [PATCH 08/19] mach-davinci: move DaVinci TNET GPIO driver to
 GPIO subsystem
Thread-Index: AcxYJ3EuobNY4nIlSYCoJt3JevRg6wBDj1fA
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024E0503B7@dbde02.ent.ti.com>
References: <1312978639-18339-1-git-send-email-linus.walleij@stericsson.com>
	<B85A65D85D7EB246BE421B3FB0FBB593024E04F945@dbde02.ent.ti.com>
 <CACRpkdZvxvD01ofxMxDb3wXpt9_8wkU1rwxdLj5RuidoZNrb+w@mail.gmail.com>
In-Reply-To: <CACRpkdZvxvD01ofxMxDb3wXpt9_8wkU1rwxdLj5RuidoZNrb+w@mail.gmail.com>
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

On Thu, Aug 11, 2011 at 18:36:07, Linus Walleij wrote:
> On Thu, Aug 11, 2011 at 12:21 AM, Nori, Sekhar <nsekhar@ti.com> wrote:
> > Hi Linus,
> >
> > On Wed, Aug 10, 2011 at 17:47:19, Linus Walleij wrote:
> >> From: Linus Walleij <linus.walleij@linaro.org>
> >>
> >> As per example from the other ARM boards, push the DaVinci TNET
> >> GPIO driver down to the GPIO subsystem so it can be consolidated.
> >>
> >> Cc: Sekhar Nori <nsekhar@ti.com>
> >> Cc: Kevin Hilman <khilman@ti.com>
> >> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> >
> > There should be no need of this since the TNETV107x
> > GPIO can simply be supported using the basic MMIO GPIO
> > driver. I submitted patches for that a while back
> > but have some comments from Grant to address. He requested
> > some changes to be done to the basic MMIO GPIO driver
> > itself.
> >
> > https://lkml.org/lkml/2011/7/5/16
> >
> > I do plan to rework those patches and post them back.
> 
> OK I will keep this around in case it doesn't happen
> soon, it certainly does not make matters worse
> anyway.

I am OK either way. Its going to be Grant's call since
it will result in some churn in GPIO tree.

Thanks,
Sekhar
