Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758640Ab1DYQnM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 12:43:12 -0400
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:53051 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754005Ab1DYQnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 12:43:10 -0400
From: Keshava Munegowda <keshava_mgowda@ti.com>
References: <20110411093214.GA18215@rainbow><4DA3350E.2060400@gmail.com><BANLkTinDMZ+CyGCmzZu8cSz1L_yFXxm+vg@mail.gmail.com><112ef82aebc719ef25cde126f2014ebc@mail.gmail.com><20110412040420.GB25239@rainbow><bcd954a468e6a07bd673b7d0731e9344@mail.gmail.com><4DB0D58E.4030508@signal11.us><8712165194c49f0b4d8c1bd1fe717b8a@mail.gmail.com><4DB58108.4040708@signal11.us>
 <BANLkTinn7C2gVKg4v8dbUxo7yYycdFM8PA@mail.gmail.com>
MIME-Version: 1.0
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <BANLkTinn7C2gVKg4v8dbUxo7yYycdFM8PA@mail.gmail.com>
Thread-Index: AcwDU16HkKORDxccSZKD9a+ZdCxiSQAE/QKA
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5931
Date: Mon, 25 Apr 2011 22:11:55 +0530
Message-ID: <0e9c63ec5ebfd57af1ac3318e436efb9@mail.gmail.com>
Subject: RE: [Regression?] Removed regulator support in ehci-omap
To: Steve Sakoman <sakoman@gmail.com>, Alan Ott <alan@signal11.us>
Cc: Dmitry Artamonow <mad_soft@inbox.ru>, Steve Calfee <stevecalfee@gmail.com>,
        Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Steve Sakoman [mailto:sakoman@gmail.com]
> Sent: Monday, April 25, 2011 7:46 PM
> To: Alan Ott
> Cc: Keshava Munegowda; Dmitry Artamonow; Steve Calfee; Felipe Balbi;
linux-usb@vger.kernel.org;
> linux-omap@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [Regression?] Removed regulator support in ehci-omap
>
> On Mon, Apr 25, 2011 at 7:11 AM, Alan Ott <alan@signal11.us> wrote:
> > On 04/24/2011 02:37 AM, Keshava Munegowda wrote:
> >>> -----Original Message-----
> >>> From: Alan Ott [mailto:alan@signal11.us]
> >>> Sent: Friday, April 22, 2011 6:41 AM
> >>> To: Keshava Munegowda
> >>> Cc: Dmitry Artamonow; Steve Sakoman; Steve Calfee; Felipe Balbi;
> >> linux-usb@vger.kernel.org; linux-
> >>> omap@vger.kernel.org; linux-kernel@vger.kernel.org
> >>> Subject: Re: [Regression?] Removed regulator support in ehci-omap
> >>>
> >>> On 04/12/2011 12:20 PM, Keshava Munegowda wrote:
> >>>>> Ah, so EHCI/OHCI common code was moved into drivers/mfd... Good.
> >>>>> But seems regulators support was lost somewhere during transition
-
> >> the
> >>>>> only mentioning about regulators in omap-usb-host.c is "#include"
:
> >>>>>
> >>>>> mad@macmini:~/kernel-hack/linux-2.6(master)$ grep -i regulator
> >>>> drivers/mfd/omap-usb-host.c
> >>>> Thanks ! I will add some time next week!
> >>> I have confirmed this on my BeagleBoard-xM. 2.6.38 works, but the
> >>> 2.6.39-rc4+ head from yesterday did not. It seems that the regulator
> >>> does not turn the power on for the USB hub which the ethernet is
> >>> attached to.
> >>>
> >>> I connected this issue to bug 33092 in bugzilla[1].
> >>>
> >>> Alan.
> >>>
> >>> [1] https://bugzilla.kernel.org/show_bug.cgi?id=33092
> >> I have posted the patches on April 22, 2011.
> >> If possible I request you to test this.
> >
> > Hi Keshava,
> >
> > If you mean this patch[1], then I tested it against the head and it
> > didn't fix my problem. I couldn't convince myself that your patch was
> > supposed to be the whole fix to my problem (since it wasn't mentioned
on
> > this thread) so I didn't reply with my findings. Sorry about that.
>
> Same here.  The real issue (at least for Overo) turned out to be:
>
> https://lkml.org/lkml/2011/4/14/45
>
> Steve

But, I was not aware of the fix of the link:
https://lkml.org/lkml/2011/4/14/45
Sorry for this.
Same fix works for beagle-XM and I have tested this.
