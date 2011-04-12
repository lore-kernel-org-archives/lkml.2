Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758140Ab1DLQUX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 12:20:23 -0400
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:43926 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757651Ab1DLQUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 12:20:22 -0400
From: Keshava Munegowda <keshava_mgowda@ti.com>
References: <20110411093214.GA18215@rainbow> <4DA3350E.2060400@gmail.com>
 <BANLkTinDMZ+CyGCmzZu8cSz1L_yFXxm+vg@mail.gmail.com> <112ef82aebc719ef25cde126f2014ebc@mail.gmail.com>
 <20110412040420.GB25239@rainbow>
MIME-Version: 1.0
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <20110412040420.GB25239@rainbow>
Thread-Index: Acv4x58AGR54YxbFTl+tMW93j06KfAAZcBDA
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5931
Date: Tue, 12 Apr 2011 21:50:05 +0530
Message-ID: <bcd954a468e6a07bd673b7d0731e9344@mail.gmail.com>
Subject: RE: [Regression?] Removed regulator support in ehci-omap
To: Dmitry Artamonow <mad_soft@inbox.ru>
Cc: Steve Sakoman <sakoman@gmail.com>, Steve Calfee <stevecalfee@gmail.com>,
        Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=KOI8-R
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Dmitry Artamonow [mailto:mad_soft@inbox.ru]
> Sent: Tuesday, April 12, 2011 9:41 AM
> To: Keshava Munegowda
> Cc: Steve Sakoman; Steve Calfee; Felipe Balbi;
linux-usb@vger.kernel.org; linux-omap@vger.kernel.org;
> linux-kernel@vger.kernel.org
> Subject: Re: [Regression?] Removed regulator support in ehci-omap
>
> On 02:18 Tue 12 Apr     , Keshava Munegowda wrote:
> >
> > Sorry guys! I will work on it coming week; currently I am in travel.
> >
> > Well, regulator is not removed, its moved to usbhs core driver in
> > /driver/mfd/omap xx usb xxx host.c
>
> Ah, so EHCI/OHCI common code was moved into drivers/mfd... Good.
> But seems regulators support was lost somewhere during transition - the
> only mentioning about regulators in omap-usb-host.c is "#include" :
>
> mad@macmini:~/kernel-hack/linux-2.6(master)$ grep -i regulator
drivers/mfd/omap-usb-host.c
> #include <linux/regulator/consumer.h>
> mad@macmini:~/kernel-hack/linux-2.6(master)$
>
> --
> Best regards,
> Dmitry "MAD" Artamonow

Thanks ! I will add some time next week!

Keshava Munegowda
