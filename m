Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954Ab1DKUso (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 16:48:44 -0400
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:47597 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755751Ab1DKUsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 16:48:42 -0400
From: Keshava Munegowda <keshava_mgowda@ti.com>
References: <20110411093214.GA18215@rainbow><4DA3350E.2060400@gmail.com> <BANLkTinDMZ+CyGCmzZu8cSz1L_yFXxm+vg@mail.gmail.com>
MIME-Version: 1.0
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <BANLkTinDMZ+CyGCmzZu8cSz1L_yFXxm+vg@mail.gmail.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5931
Thread-Index: Acv4hNyQz7y6yqSaQemxzafGeJjcpAABJ4tg
Date: Tue, 12 Apr 2011 02:18:28 +0530
Message-ID: <112ef82aebc719ef25cde126f2014ebc@mail.gmail.com>
Subject: RE: [Regression?] Removed regulator support in ehci-omap
To: Steve Sakoman <sakoman@gmail.com>, Steve Calfee <stevecalfee@gmail.com>
Cc: Dmitry Artamonow <mad_soft@inbox.ru>, Felipe Balbi <balbi@ti.com>,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Steve Sakoman [mailto:sakoman@gmail.com]
> Sent: Tuesday, April 12, 2011 1:43 AM
> To: Steve Calfee
> Cc: Dmitry Artamonow; Keshava Munegowda; Felipe Balbi;
linux-usb@vger.kernel.org; linux-
> omap@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [Regression?] Removed regulator support in ehci-omap
>
> On Mon, Apr 11, 2011 at 10:06 AM, Steve Calfee <stevecalfee@gmail.com>
wrote:
> > On 04/11/11 02:32, Dmitry Artamonow wrote:
> >> Hi, guys!
> >>
> >> Can anyone explain why regulator support has been removed from
ehci-omap
> >> driver in commit 19403165 ("usb: host: omap: ehci and ohci
simplification")[1]?
> >> In 2.6.37/2.6.38 it was enough to apply simple patch[2] adding
regulators
> >> description to board file to make USB work on omap3evm board (because
USB PHY
> >> is powered via regulator). But now it won't work anymore in
2.6.39-rc2.
> >> BTW, I suspect that this commit also broke USB on omap3pandora board,
as it
> >> defines "hsusb0" regulator supply in its board file:
> >>
> > Yes, And Beagleboard xm (and I suspect other beagleboard versions) has
> > been broken in 2.6.39rc1+.
>
> FWIW, EHCI is also broken on Overo in both rc1 and rc2.
>
> Steve

Sorry guys! I will work on it coming week; currently I am in travel.

Well, regulator is not removed, its moved to usbhs core driver in
/driver/mfd/omap xx usb xxx host.c

Regards
Keshava Munegowda
