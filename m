Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021Ab2CLQHQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 12:07:16 -0400
Received: from ftp.meprolight.com ([194.90.149.17]:36475 "EHLO meprolight.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751542Ab2CLQHN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 12:07:13 -0400
From: Alex Gershgorin <alexg@meprolight.com>
To: Fabio Estevam <festevam@gmail.com>
CC: Fabio Estevam <fabio.estevam@freescale.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Mon, 12 Mar 2012 18:06:55 +0200
Subject: RE: I.MX35 PDK
Thread-Topic: I.MX35 PDK
Thread-Index: Ac0AU3gj9FbMBrKGSXCsPMsFN/sHngADo4Xl
Message-ID: <4875438356E7CA4A8F2145FCD3E61C0B2CBD5D891C@MEP-EXCH.meprolight.com>
References: <CAOMZO5DnP7+zupy9vwBPS0+2XtKM1+nLbwCqBzuCqEG5OWbZRQ@mail.gmail.com>
	<4875438356E7CA4A8F2145FCD3E61C0B2CBD666A28@MEP-EXCH.meprolight.com>
	<CAOMZO5Amo0XFf+TV7PprCL079C5Y0qKmo+k-FfShU7k4SG7W6Q@mail.gmail.com>
	<4875438356E7CA4A8F2145FCD3E61C0B2CBD5D8913@MEP-EXCH.meprolight.com>
	<4875438356E7CA4A8F2145FCD3E61C0B2CBD5D8918@MEP-EXCH.meprolight.com>
	<CAOMZO5A6T+WdOE41Wx6Nctwz9wk8FKaxzjbAt_woZkCnuodNYg@mail.gmail.com>
	<4875438356E7CA4A8F2145FCD3E61C0B2CBD666A29@MEP-EXCH.meprolight.com>,<CAOMZO5B_mZ16zvXdNbKP_PWM5axNPzMeHQttxe8PYHET7UMufg@mail.gmail.com>
In-Reply-To: <CAOMZO5B_mZ16zvXdNbKP_PWM5axNPzMeHQttxe8PYHET7UMufg@mail.gmail.com>
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

Thanks for your response,

> 1. Back resistor 172 to the default value.
>
> 2. Removed the resistor 146, through which a voltage was applied from a PMIC
> (EXT_3V) on "CMOS_VIO".
>
> 3. Connecting a resistor 147 which supplies power from the LDO_3V3 on
> "CMOS_VIO".

> >The camera on the FSL BSP works fine with no hardware modification on
> >the mx35pdk.

> >As I suggested previously you should control the power rails, i2c pad
> >settings, etc from software so that the camera can also work in
> >mainline without the need of changing the hardware.

You're right, currently mainline Linux kernel  i.MX35 PDK platform does not support power management 
devices, probably for this reason was the need for small changes in equipment.

> On my display I see snow flickering and unfortunately not a live video from
> camera.

> >Do you have this patch applied?

Yes I need to prepare it.


 > >http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=f910fb8fcd1c97788f2291c8646597bcd87ee061

> >Also, try to isolate the display from this issue. Capture the image to
> >a file and try to play it on a PC.

Thanks for the tip, I'll think about how I can check it.

Regards

Alex Gershgorin 

 
