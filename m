Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224Ab2CZCcH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 22:32:07 -0400
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:57033 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755404Ab2CZCcF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 22:32:05 -0400
From: Arun MURTHY <arun.murthy@stericsson.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Date: Mon, 26 Mar 2012 04:31:06 +0200
Subject: RE: linux-next: build failure after merge of the battery tree
Thread-Topic: linux-next: build failure after merge of the battery tree
Thread-Index: Ac0K9gzKBrlX08xhSpigBAX5br1x0wAAja+g
Message-ID: <F45880696056844FA6A73F415B568C6958BEEDDB7F@EXDCVYMBSTM006.EQ1STM.local>
References: <20120315135609.2f9a2a030866c476dc736b9c@canb.auug.org.au>
	<20120320153912.b97107ca4128d0692de17799@canb.auug.org.au>
 <20120326131316.b791ebefd94d8cbcac5bccfa@canb.auug.org.au>
In-Reply-To: <20120326131316.b791ebefd94d8cbcac5bccfa@canb.auug.org.au>
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

> > > drivers/power/ab8500_btemp.c: In function
> 'ab8500_btemp_batctrl_volt_to_res':
> > > drivers/power/ab8500_btemp.c:142:2: error: implicit declaration of
> > > function 'is_ab8500_1p1_or_earlier'
> > > [-Werror=implicit-function-declaration]
> > > drivers/power/ab8500_btemp.c: In function
> 'ab8500_btemp_templow_handler':
> > > drivers/power/ab8500_btemp.c:619:2: error: implicit declaration of
> > > function 'is_ab8500_2p0_or_earlier'
> > > [-Werror=implicit-function-declaration]
> > > drivers/power/ab8500_charger.c: In function 'ab8500_charger_ac_en':
> > > drivers/power/ab8500_charger.c:1126:3: error: implicit declaration
> > > of function 'is_ab8500_1p1_or_earlier'
> > > [-Werror=implicit-function-declaration]
> > > drivers/power/ab8500_charger.c: In function
> 'ab8500_charger_remove':
> > > drivers/power/ab8500_charger.c:2519:2: error: implicit declaration
> > > of function 'usb_unregister_notifier'
> > > [-Werror=implicit-function-declaration]
> > > drivers/power/ab8500_charger.c:2520:2: error: implicit declaration
> > > of function 'usb_put_transceiver'
> > > [-Werror=implicit-function-declaration]
> > > drivers/power/ab8500_charger.c: In function 'ab8500_charger_probe':
> > > drivers/power/ab8500_charger.c:2688:2: error: implicit declaration
> > > of function 'usb_get_transceiver'
> > > [-Werror=implicit-function-declaration]
> > > drivers/power/ab8500_charger.c:2688:14: warning: assignment makes
> > > pointer from integer without a cast [enabled by default]
> > > drivers/power/ab8500_charger.c:2695:2: error: implicit declaration
> > > of function 'usb_register_notifier'
> > > [-Werror=implicit-function-declaration]
> > >
> > > Caused by commits 89449ac8d6d2 ("ab8500-charger: AB8500 charger
> > > driver") and 20ac1aed6206 ("ab8500-btemp: AB8500 battery
> temperature driver").
> > >
> > > I have used the battery tree form next-20120314 for today.
> >
> > Still getting this build failure.

There is a dependency with MFD tree. Please pull the MFD tree along with
these patches to overcome the build errors.

Thanks and Regards,
Arun R Murthy
-------------
