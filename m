Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120Ab2LSUgF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 15:36:05 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:52437 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643Ab2LSUfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 15:35:43 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v2] gpio: add TS-5500 DIO blocks support
To: Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Cc: linux-kernel@vger.kernel.org,
        Jerome Oufella <jerome.oufella@savoirfairelinux.com>
In-Reply-To: <CACRpkdbjWz99SEV1gZKiNhiCS2k_CT+oznorNDpw=hvyF49Gkg@mail.gmail.com>
References: <1354934194-28213-1-git-send-email-vivien.didelot@savoirfairelinux.com> <CACRpkdbjWz99SEV1gZKiNhiCS2k_CT+oznorNDpw=hvyF49Gkg@mail.gmail.com>
Date: Wed, 19 Dec 2012 17:16:00 +0000
Message-Id: <20121219171600.7B0EF3E0C5A@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Dec 2012 10:55:04 +0100, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Sat, Dec 8, 2012 at 3:36 AM, Vivien Didelot
> <vivien.didelot@savoirfairelinux.com> wrote:
> 
> > Technologic Systems TS-5500 provides digital I/O lines exposed through
> > pin blocks. On this platform, there are three of them, named DIO1, DIO2
> > and LCD port, that may be used as a DIO block.
> >
> > The TS-5500 pin blocks are described in the product's wiki:
> > http://wiki.embeddedarm.com/wiki/TS-5500#Digital_I.2FO
> >
> > This driver is not limited to the TS-5500 blocks. It can be extended to
> > support similar boards pin blocks, such as on the TS-5600.
> >
> > This patch is the V2 of the previous https://lkml.org/lkml/2012/9/25/671
> > with corrections suggested by Linus Walleij.
> >
> > Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
> > Signed-off-by: Jerome Oufella <jerome.oufella@savoirfairelinux.com>
> 
> Thanks Vivien, it's looking *very* nice and clean now, so patch applied!
> 
> It's perfectly OK this late before the merge window since it's a new driver.
> 
> Yours,
> Linus Walleij

Wait a minute.... this driver looks very much like gpio-generic. It
really should be using that interface, not recreating all the gpio
infrastructure that has been done so many times before.

Please take a look at either send me a follow-on patch to convert it to
use gpio-generic, or tell my why gpio-generic isn't appropriate here.
It's already in, so I'm not got to take it back out (that wouldn't be
very fair), but I may decide to move it to staging.

g.

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
