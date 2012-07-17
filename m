Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451Ab2GQJQF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 05:16:05 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:50838 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab2GQJQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 05:16:02 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
Subject: Re: [PATCH 1/2] drivers: bus: add a new driver for omap-ocp2scp
Date: Tue, 17 Jul 2012 08:00:42 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux@arm.linux.org.uk, b-cousson@ti.com, rnayak@ti.com,
        tony@atomide.com, gregkh@linuxfoundation.org, ohad@wizery.com,
        linus.walleij@linaro.org, myungjoo.ham@samsung.com,
        rusty@rustcorp.com.au, swarren@nvidia.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        balbi@ti.com, linux-omap@vger.kernel.org, linux-usb@vger.kernel.org
References: <1342448023-14438-1-git-send-email-kishon@ti.com> <1342448023-14438-2-git-send-email-kishon@ti.com> <CAAe_U6K9sm-sDK80ySSHPGf5SYuwDkhW+4q8r2deXi7Tz3TxJw@mail.gmail.com>
In-Reply-To: <CAAe_U6K9sm-sDK80ySSHPGf5SYuwDkhW+4q8r2deXi7Tz3TxJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207170800.43300.arnd@arndb.de>
X-Provags-ID: V02:K0:sRTscPAgv2Q87wulw2gJxsneEEIDTC7RDquyLAXQzDt
 LBsL+kwC06OQGLm4nS0sqxd3XUkKpSqGXRSlErMTU6UJsiGlFV
 gAZ1efxpNk3dFhlguHMFwCOTE8PCGb8LLKLX9EuLSj5znjm1oi
 EI492oM+eoRg+fQDnu6nOkH7NK8Ykid1ogXcW7Rx86QkYJXL5Y
 tx9h/QXe8J4ba8YmQx0cZHsPk9752MH6zYoabZidKmecfcMaR1
 hR6RUd0/nGqaMUaNJWnRSkGRp2CZ562/TSDQaPsZdelRFTDltk
 8WO0isPjYjc6l1WC7PGozQ3f7zpgDc9KOJahgGFWKTIeWlL7wo
 wObpEXepIoqKrPp8Em88=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 July 2012, ABRAHAM, KISHON VIJAY wrote:
> On Mon, Jul 16, 2012 at 7:43 PM, Kishon Vijay Abraham I <kishon@ti.com> wrote:
> > Adds a new driver *omap-ocp2scp*. This driver takes the responsibility of
> > creating all the devices that is connected to OCP2SCP. In the case of OMAP4,
> > USB2PHY is connected to ocp2scp.
> >
> > This also includes device tree support for ocp2scp driver and
> > the documentation with device tree binding information is updated.
> >
> > Cc: Felipe Balbi <balbi@ti.com>
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>

Now that we've found a place for the code to live, do we know which maintainer is
going to pick it up? If nobody else volunteers, we can take it through the
arm-soc tree.

	Arnd

