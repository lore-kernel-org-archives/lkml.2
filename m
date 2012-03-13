Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371Ab2CMNu6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 09:50:58 -0400
Received: from mail.meprolight.com ([194.90.149.17]:41198 "EHLO meprolight.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754079Ab2CMNu5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 09:50:57 -0400
From: Alex Gershgorin <alexg@meprolight.com>
To: "'Sascha Hauer'" <s.hauer@pengutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>,
        "fabio.estevam@freescale.com" <fabio.estevam@freescale.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>
Date: Tue, 13 Mar 2012 15:50:35 +0200
Subject: RE: [PATCH] i.MX35-PDK: Add Camera support
Thread-Topic: [PATCH] i.MX35-PDK: Add Camera support
Thread-Index: Ac0BHeCcjfU57P2oSCqY3JiYQLFBhQAAFUQg
Message-ID: <4875438356E7CA4A8F2145FCD3E61C0B2CBD666A2A@MEP-EXCH.meprolight.com>
In-Reply-To: <20120313133333.GG3852@pengutronix.de>
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

Hi Sascha,

Thanks for you comments.
 
> In i.MX35-PDK, OV2640  camera is populated on the
> personality board. This camera is registered as a subdevice via soc-camera interface.
> 
> Signed-off-by: Alex Gershgorin <alexg@meprolight.com>
> ---
>  arch/arm/mach-imx/mach-mx35_3ds.c |   87 +++++++++++++++++++++++++++++++++++++
>  1 files changed, 87 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-imx/mach-mx35_3ds.c b/arch/arm/mach-imx/mach-mx35_3ds.c

> > This one does not apply as it is obviously based on (an earlier version
> > of) the framebuffer patches of this board. Please always base your stuff
> > on some -rc kernel. We can resolve conflicts later upstream, but we
> > cannot easily apply a patch when we do not have the correct base.

> >Please add the linux arm kernel mailing list next time.

Oh what a stupid mistake, I will correct it.

Regards,

Alex Gershgorin
