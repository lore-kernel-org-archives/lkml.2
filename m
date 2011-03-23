Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932470Ab1CWOgK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 10:36:10 -0400
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:41780 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756097Ab1CWOgH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 10:36:07 -0400
From: Par-Gunnar HJALMDAHL <par-gunnar.p.hjalmdahl@stericsson.com>
To: Greg KH <gregkh@suse.de>
Cc: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        Pavan Savoy <pavan_savoy@sify.com>, Vitaly Wool <vitalywool@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Marcel Holtmann <marcel@holtmann.org>,
        Lukasz Rymanowski <Lukasz.Rymanowski@tieto.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Par-Gunnar Hjalmdahl <pghatwork@gmail.com>,
        Lee Jones <lee.jones@linaro.org>
Date: Wed, 23 Mar 2011 15:35:27 +0100
Subject: RE: [PATCH 2/2] mach-ux500: Add CG2900 devices
Thread-Topic: [PATCH 2/2] mach-ux500: Add CG2900 devices
Thread-Index: AcvpZuY4DTFVyG4ATP6mGlERu1TqJAAADWlA
Message-ID: <AFCDDB4A3EA003429EEF1E7B211FDBBA334C4DE825@EXDCVYMBSTM005.EQ1STM.local>
References: <1300888803-26474-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com>
 <20110323142719.GA17369@suse.de>
In-Reply-To: <20110323142719.GA17369@suse.de>
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

Hi Greg,

> -----Original Message-----
> From: Greg KH [mailto:gregkh@suse.de]
> Sent: den 23 mars 2011 15:27
> To: Par-Gunnar HJALMDAHL
> Cc: devel@driverdev.osuosl.org; Linus Walleij; linux-
> kernel@vger.kernel.org; linux-bluetooth@vger.kernel.org; Pavan Savoy;
> Vitaly Wool; Alan Cox; Arnd Bergmann; Marcel Holtmann; Lukasz
> Rymanowski; Linus WALLEIJ; Par-Gunnar Hjalmdahl; Lee Jones
> Subject: Re: [PATCH 2/2] mach-ux500: Add CG2900 devices
> 
> On Wed, Mar 23, 2011 at 03:00:03PM +0100, Par-Gunnar Hjalmdahl wrote:
> > This patch adds the board specific data for the CG2900
> > driver on a UX500 board.
> >
> > Signed-off-by: Par-Gunnar Hjalmdahl <par-
> gunnar.p.hjalmdahl@stericsson.com>
> > Acked-by: Linus Walleij <linus.walleij@linaro.org>
> > ---
> >  arch/arm/mach-ux500/Makefile         |    4 +
> >  arch/arm/mach-ux500/board-mop500.c   |  160 ++++++++++++++++
> >  arch/arm/mach-ux500/devices-cg2900.c |  349
> ++++++++++++++++++++++++++++++++++
> >  arch/arm/mach-ux500/devices-cg2900.h |   19 ++
> >  4 files changed, 532 insertions(+), 0 deletions(-)
> >  create mode 100644 arch/arm/mach-ux500/devices-cg2900.c
> >  create mode 100644 arch/arm/mach-ux500/devices-cg2900.h
> 
> As this touches ARM specific code, I need an ack from the ARM
> maintainer
> before I can take this through the staging tree.  Is there any way to
> make it part of your drivers/staging/ submission?  There are other
> examples in the staging tree already that do this, why not do that here
> as well?
> 
> thanks,
> 
> greg k-h

I've been discussing this with Linus Walleij, who is the maintainer of
arch/arm/mach-ux500.
He suggested that I should let this be a separate patch and that I
should include it in the same patch set where he would pick the patch
from it.
I guess he will respond soon since he's on cc.

/P-G
