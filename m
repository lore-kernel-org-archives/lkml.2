Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757653Ab1IAOdY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 10:33:24 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58097 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757629Ab1IAOdX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 10:33:23 -0400
From: "Nori, Sekhar" <nsekhar@ti.com>
To: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, "Hilman, Kevin" <khilman@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>
Date: Thu, 1 Sep 2011 20:02:51 +0530
Subject: RE: [PATCH] [ARM] davinci: gpio: eliminate unused variable warnings
Thread-Topic: [PATCH] [ARM] davinci: gpio: eliminate unused variable warnings
Thread-Index: AcxbDgV88JJkusAlRrCy0wMtEe+jHANoaxHg
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB5930257268CEC@dbde02.ent.ti.com>
References: <1313386893.25484.1.camel@phoenix>
In-Reply-To: <1313386893.25484.1.camel@phoenix>
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

Hi Axel,

On Mon, Aug 15, 2011 at 11:11:33, Axel Lin wrote:
> Since commit 5093aec872e5be7a55d8dd2b639e8a3818dc19db
> "arm: davinci: Cleanup irq chip code", 
> the variable 'mask' and 'g' are not being used in gpio_irq_type.
> 
> This patch eliminate below unused variable warnings:
> 
>   CC      arch/arm/mach-davinci/gpio.o
> arch/arm/mach-davinci/gpio.c: In function 'gpio_irq_type':
> arch/arm/mach-davinci/gpio.c:234: warning: unused variable 'mask'
> arch/arm/mach-davinci/gpio.c:233: warning: unused variable 'g'
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Thanks for the fix! There is a patch in linux-next
committed by Russell which moves the DaVinci gpio driver
to drivers/gpio/. 

Can you please redo this fix to apply on linux-next?

Once Russell approves, it can go though his patch
system so there are no conflicts.

Thanks,
Sekhar

