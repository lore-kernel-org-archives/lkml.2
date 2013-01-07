Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014Ab3AGJVi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 04:21:38 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:51570 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753625Ab3AGJVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 04:21:35 -0500
From: "Mohammed, Afzal" <afzal@ti.com>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
CC: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        "Valkeinen, Tomi" <tomi.valkeinen@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        "Nori, Sekhar" <nsekhar@ti.com>, "Hiremath, Vaibhav" <hvaibhav@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: RE: [PATCH 08/10] video: da8xx-fb: obtain fb_videomode info from dt
Thread-Topic: [PATCH 08/10] video: da8xx-fb: obtain fb_videomode info from dt
Thread-Index: AQHN6olgYao2ec3g5EedwyKq/6QVMZg9PLCAgABdw5A=
Date: Mon, 7 Jan 2013 09:21:15 +0000
Message-ID: <C8443D0743D26F4388EA172BF4E2A7A93EA7FC7A@DBDE01.ent.ti.com>
References: <cover.1357304090.git.afzal@ti.com>
 <78e026555731e0bbe8475610279d3e5265d124b9.1357304090.git.afzal@ti.com>
 <20130107091131.GC23478@pengutronix.de>
In-Reply-To: <20130107091131.GC23478@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r079LeJ8026085

Hi Steffen,

On Mon, Jan 07, 2013 at 14:41:31, Steffen Trumtrar wrote:
> On Mon, Jan 07, 2013 at 10:41:30AM +0530, Afzal Mohammed wrote:

> > Obtain fb_videomode details for the connected lcd panel using the
> > display timing details present in DT.

> > +- display-timings: list of different videomodes supported by the lcd
> > +  panel, represented as childs, can have multiple modes supported, if
> > +  only one, then it is considered native mode, if multiple modes are
> > +  provided, native mode can be set explicitly, more details available
> > +  @Documentation/devicetree/bindings/video/display-timing.txt

> Keep in mind that the text combined with...

> > +		if (of_get_fb_videomode(np, lcdc_info, 0)) {
> > +			dev_err(&dev->dev, "timings not available in DT\n");
> > +			return NULL;
> > +		}
> > +		return lcdc_info;
> > +	}
> 
> ... this is not correct. You are just supporting the first display-timings
> subnode (of_get_fb_videomode(..., 0)).


Yes right, I will modify the text to reflect what the driver does.

Regards
Afzal
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
