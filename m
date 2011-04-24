Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716Ab1DXGhu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 02:37:50 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:42308 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753174Ab1DXGhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 02:37:46 -0400
From: Keshava Munegowda <keshava_mgowda@ti.com>
References: <20110411093214.GA18215@rainbow> <4DA3350E.2060400@gmail.com>
 <BANLkTinDMZ+CyGCmzZu8cSz1L_yFXxm+vg@mail.gmail.com> <112ef82aebc719ef25cde126f2014ebc@mail.gmail.com>
 <20110412040420.GB25239@rainbow> <bcd954a468e6a07bd673b7d0731e9344@mail.gmail.com>
 <4DB0D58E.4030508@signal11.us>
MIME-Version: 1.0
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <4DB0D58E.4030508@signal11.us>
Thread-Index: AcwAihquHle5NbAyR4CYpdRlqPJk9QBv7twA
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5931
Date: Sun, 24 Apr 2011 12:07:21 +0530
Message-ID: <8712165194c49f0b4d8c1bd1fe717b8a@mail.gmail.com>
Subject: RE: [Regression?] Removed regulator support in ehci-omap
To: Alan Ott <alan@signal11.us>
Cc: Dmitry Artamonow <mad_soft@inbox.ru>, Steve Sakoman <sakoman@gmail.com>,
        Steve Calfee <stevecalfee@gmail.com>, Felipe Balbi <balbi@ti.com>,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Alan Ott [mailto:alan@signal11.us]
> Sent: Friday, April 22, 2011 6:41 AM
> To: Keshava Munegowda
> Cc: Dmitry Artamonow; Steve Sakoman; Steve Calfee; Felipe Balbi;
linux-usb@vger.kernel.org; linux-
> omap@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [Regression?] Removed regulator support in ehci-omap
>
> On 04/12/2011 12:20 PM, Keshava Munegowda wrote:
> >> Ah, so EHCI/OHCI common code was moved into drivers/mfd... Good.
> >> But seems regulators support was lost somewhere during transition -
the
> >> only mentioning about regulators in omap-usb-host.c is "#include" :
> >>
> >> mad@macmini:~/kernel-hack/linux-2.6(master)$ grep -i regulator
> > drivers/mfd/omap-usb-host.c
> > Thanks ! I will add some time next week!
>
> I have confirmed this on my BeagleBoard-xM. 2.6.38 works, but the
> 2.6.39-rc4+ head from yesterday did not. It seems that the regulator
> does not turn the power on for the USB hub which the ethernet is
> attached to.
>
> I connected this issue to bug 33092 in bugzilla[1].
>
> Alan.
>
> [1] https://bugzilla.kernel.org/show_bug.cgi?id=33092

I have posted the patches on April 22, 2011.
If possible I request you to test this.

Keshava Munegowda
