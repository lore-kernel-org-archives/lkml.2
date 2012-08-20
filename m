Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539Ab2HTH0p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 03:26:45 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:49891 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755292Ab2HTH0n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 03:26:43 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Bryan Wu <bryan.wu@canonical.com>,
        "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] leds-lm3530: replace pwm platform functions with
 generic pwm functions
Thread-Topic: [PATCH] leds-lm3530: replace pwm platform functions with
 generic pwm functions
Thread-Index: Ac1+iI3X+iN5rabESjyXTrhr06HT3P//lKUA//95SCCAAJmqgP//dkPw
Date: Mon, 20 Aug 2012 07:26:29 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF0955@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F41EF0095@DQHE02.ent.ti.com>
 <201208200537.48993.arnd@arndb.de>
 <A874F61F95741C4A9BA573A70FE3998F41EF092A@DQHE02.ent.ti.com>
 <201208200645.38047.arnd@arndb.de>
In-Reply-To: <201208200645.38047.arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In that case, I would recommend changing it from
> 
> +       /* if the pwm device exists, skip requesting the device */
> +       if (drvdata->pwm)
> +               return 0;
> 
> to
> 
> 	/* warn if the PWM was not released prior to reneabling it */
> 	WARN_ON(drvdata->pwm);
> 

OK, thanks for your comments!

Best Regards,
Milo



