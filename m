Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757499Ab2IQXOu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 19:14:50 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:40897 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754975Ab2IQXOs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 19:14:48 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Bryan Wu <bryan.wu@canonical.com>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Question about cleaning up the LP5521/5523 LED driver
Thread-Topic: Question about cleaning up the LP5521/5523 LED driver
Thread-Index: Ac2Ux5p32LFQ6BkaSD2YmDg6N4ig1v//n6oA//7a3gA=
Date: Mon, 17 Sep 2012 23:14:41 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF52A7@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F41EF514F@DQHE02.ent.ti.com>
 <CACRpkdYQ8X7iwvHoecwYs1TZG_yP281FR-ZN7JCO=HUVp-05Ew@mail.gmail.com>
In-Reply-To: <CACRpkdYQ8X7iwvHoecwYs1TZG_yP281FR-ZN7JCO=HUVp-05Ew@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.87.185.123]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Should I keep the sysfs layout of LP5521 and LP5523?
> > When we change the device attributes, do we have to consider the
> backward compatibility?
> 
> The ABI is a contract so basically yes, you need real good reasons
> (like security concerns) to change the ABI.
> 
> That said, the lm3533 is the only LED driver that has actually
> documented
> its ABI: Documentation/ABI/testing/sysfs-class-led-driver-lm3533

OK, thanks for your great help !

Best Regards,
Milo
