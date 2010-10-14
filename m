Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab0JNCK2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 22:10:28 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:41670 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753827Ab0JNCK1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 22:10:27 -0400
From: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
To: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
CC: "felipe.contreras@nokia.com" <felipe.contreras@nokia.com>,
        "ameya.palande@nokia.com" <ameya.palande@nokia.com>,
        "david.cohen@nokia.com" <david.cohen@nokia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andy.shevchenko@gmail.com" <andy.shevchenko@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Date: Wed, 13 Oct 2010 21:10:20 -0500
Subject: RE: [PATCH] iovmm: IVA2 MMU range is from 0x11000000 to 0xFFFFFFFF
Thread-Topic: [PATCH] iovmm: IVA2 MMU range is from 0x11000000 to 0xFFFFFFFF
Thread-Index: ActmU/Juj8uAoZG8Rbqg0cBBx/615gE8Mwvw
Message-ID: <496565EC904933469F292DDA3F1663E602F47B36A1@dlee06.ent.ti.com>
References: <1286477021-23169-1-git-send-email-x0095840@ti.com>
 <20101007.221401.226802875.Hiroshi.DOYU@nokia.com>
In-Reply-To: <20101007.221401.226802875.Hiroshi.DOYU@nokia.com>
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
> From: Hiroshi DOYU [mailto:Hiroshi.DOYU@nokia.com] 
> Sent: Thursday, October 07, 2010 2:14 PM
> To: Guzman Lugo, Fernando
> Cc: felipe.contreras@nokia.com; ameya.palande@nokia.com; 
> david.cohen@nokia.com; linux-kernel@vger.kernel.org; 
> andy.shevchenko@gmail.com; linux-omap@vger.kernel.org
> Subject: Re: [PATCH] iovmm: IVA2 MMU range is from 0x11000000 
> to 0xFFFFFFFF
> 
> From: ext Fernando Guzman Lugo <x0095840@ti.com>
> Subject: [PATCH] iovmm: IVA2 MMU range is from 0x11000000 to 
> 0xFFFFFFFF
> Date: Thu, 7 Oct 2010 20:43:41 +0200
> 
> > IV2 MMU capable addresses start from 0x11000000
> 
> Wouldn't it be better to add an general API to configure the 
> valid 'da' range in advance?
> 
> I don't think that it's a good idea to introduce the iommu
> instance("iva2:iommu") specific code here.

Please discard this patch. I will send a one base on comments
Along with the other iommu fixes serie.

Regards,
Fernando.

> 