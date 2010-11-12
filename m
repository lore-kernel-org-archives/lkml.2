Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567Ab0KLN1R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 08:27:17 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:48993 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757262Ab0KLN1P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 08:27:15 -0500
From: "G, Manjunath Kondaiah" <manjugk@ti.com>
To: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm@lists.arm.linux.org.uk" <linux-arm@lists.arm.linux.org.uk>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>
Date: Fri, 12 Nov 2010 18:57:02 +0530
Subject: RE: [PATCHv4 0/4] OMAP: Serial: remove magic and diplicates
Thread-Topic: [PATCHv4 0/4] OMAP: Serial: remove magic and diplicates
Thread-Index: AcuCbFVM6rmHNK87RSeqMTFhjuMeowAADKfw
Message-ID: <E0D41E29EB0DAC4E9F3FF173962E9E9402DC24F069@dbde02.ent.ti.com>
References: <1289567043-6213-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
	<E0D41E29EB0DAC4E9F3FF173962E9E9402DC24F05C@dbde02.ent.ti.com>
 <AANLkTin-j1Aww+Nu4zRdAP5TH-t+ftpW6VEWUdejb1Pn@mail.gmail.com>
In-Reply-To: <AANLkTin-j1Aww+Nu4zRdAP5TH-t+ftpW6VEWUdejb1Pn@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

> -----Original Message-----
> From: Andrei Emeltchenko [mailto:andrei.emeltchenko.news@gmail.com] 
> Sent: Friday, November 12, 2010 6:50 PM
> To: G, Manjunath Kondaiah
> Cc: linux-omap@vger.kernel.org; linux-kernel@vger.kernel.org; 
> linux-arm@lists.arm.linux.org.uk; linux-serial@vger.kernel.org
> Subject: Re: [PATCHv4 0/4] OMAP: Serial: remove magic and diplicates
> 
> On Fri, Nov 12, 2010 at 3:17 PM, G, Manjunath Kondaiah 
> <manjugk@ti.com> wrote:
> >
> >
> >> -----Original Message-----
> >> From: linux-omap-owner@vger.kernel.org
> >> [mailto:linux-omap-owner@vger.kernel.org] On Behalf Of
> >> Emeltchenko Andrei
> >> Sent: Friday, November 12, 2010 6:34 PM
> >> To: linux-omap@vger.kernel.org; linux-kernel@vger.kernel.org;
> >> linux-arm@lists.arm.linux.org.uk; linux-serial@vger.kernel.org
> >> Subject: [PATCHv4 0/4] OMAP: Serial: remove magic and diplicates
> >
> > s/diplicates/duplicates
> >
> >>
> >> From: Andrei Emeltchenko <andrei.emeltchenko@nokia.com>
> >>
> >> Add MDR1 Serial register definition to serial_reg and remove
> >> duplicated
> >> code, remove magic MDR1 register numbers from serial drivers.
> >>
> >> *v2 add OMAP keyword to MDR1 definition
> >> *v3 remove magic from serial drivers
> >> *v4 taking comments from Manjunath and Govindraj: typos, CC
> >>
> >> Andrei Emeltchenko (4):
> >>   OMAP: Serial: Define OMAP uart MDR1 register definitions
> >>   OMAP1: Serial: remove magic numbers for MDR1 reg
> >>   OMAP2: Serial: remove magic numbers for MDR1 reg
> >>   OMAP: Serial: remove redefined MDR1 register definitions
> >>
> >>  arch/arm/mach-omap1/serial.c                  |    6 ++++--
> >>  arch/arm/mach-omap2/serial.c                  |   15 
> +++++++++------
> >>  arch/arm/plat-omap/include/plat/omap-serial.h |    3 ---
> >>  drivers/serial/omap-serial.c                  |    6 +++---
> >>  include/linux/serial_reg.h                    |   12 ++++++++++++
> >>  5 files changed, 28 insertions(+), 14 deletions(-)
> >
> > Do you think patch series is required for these changes? How about
> > merging with single patch?
> 
> I can merge, sometimes somebody need patches to be split, 

why? can you give example?

Please read: http://lwn.net/Articles/139918/
"if you make a single change to numerous files, group those changes into 
a single patch.  Thus a single logical change is contained within a 
single patch."

-Manjunath