Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759348Ab0JZKKo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 06:10:44 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:42348 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561Ab0JZKKn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 06:10:43 -0400
From: "Nayak, Rajendra" <rnayak@ti.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
CC: Axel Lin <axel.lin@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        Juha Keski-Saari <ext-juha.1.keski-saari@nokia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Manuel, Lesly Arackal" <leslyam@ti.com>
Date: Tue, 26 Oct 2010 15:40:06 +0530
Subject: RE: [PATCH] regulator: twl-regulator - fix twlreg_set_mode
Thread-Topic: [PATCH] regulator: twl-regulator - fix twlreg_set_mode
Thread-Index: ActyuNFPXxwj6HhHRf2hO4plS+6DBQCPQjSA
Message-ID: <0680EC522D0CC943BC586913CF3768C003FF2DAF9D@dbde02.ent.ti.com>
References: <1287736702.2996.4.camel@mola>
	 <20101022153006.GB16521@opensource.wolfsonmicro.com>
 <1287841635.7486.3.camel@odin>
In-Reply-To: <1287841635.7486.3.camel@odin>
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



> -----Original Message-----
> From: Liam Girdwood [mailto:lrg@slimlogic.co.uk]
> Sent: Saturday, October 23, 2010 7:17 PM
> To: Nayak, Rajendra
> Cc: Axel Lin; linux-kernel; Juha Keski-Saari; Mark Brown
> Subject: Re: [PATCH] regulator: twl-regulator - fix twlreg_set_mode
> 
> On Fri, 2010-10-22 at 08:30 -0700, Mark Brown wrote:
> > On Fri, Oct 22, 2010 at 04:38:22PM +0800, Axel Lin wrote:
> > > The Singular Message is 16 bits:
> > >         DEV_GRP[15:13] MT[12]  RES_ID[11:4]  RES_STATE[3:0]
> > >
> > > Current implementation return immedially after sucessfuly write MSB part.
> > > To properly set mode, we need to write the complete message ( MSB and LSB ).
> > >
> > > In twl.h, now we have defines for PM Master module register offsets,
> > > use it instead of hard coded 0x15/0x16.
> > >
> > > Use "message & 0xff" to ensure we send correct value for LSB.
> > >
> > > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> >
> > Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> >
> > > I don't have this hardware handy, I appreciate if someone who has the
> > > hardware can test this patch.
> >
> > I beleive Liam has appropriate hardware.
> 
> Rejendra, care to test this ?

Sure, either me or Lesly will test this on one of the twl4030 based platforms
and update.

> 
> Thanks
> 
> Liam
> --
> Freelance Developer, SlimLogic Ltd
> ASoC and Voltage Regulator Maintainer.
> http://www.slimlogic.co.uk

