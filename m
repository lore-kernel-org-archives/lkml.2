Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933700Ab2HWJa6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 05:30:58 -0400
Received: from antcom.de ([188.40.178.216]:52945 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932259Ab2HWJa4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 05:30:56 -0400
Message-ID: <5035F84E.3000901@antcom.de>
Date: Thu, 23 Aug 2012 11:30:54 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: linux-mtd@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        s.hauer@pengutronix.de
Subject: mxc_nand.c on mach-imx/imx53
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'd like to know about the current state of mxc_nand.c on imx53, because
I got an error on probe() because the clock that mxc_nand is requesting
is "nfc" but imx53 only defines the clock "mxc_nand".

Even after adjusting the name, probe() couldn't find the clock, so I'm
wondering if mxc_nand.c is supported on imx53 at all because other mx'es
have IMX_HAVE_PLATFORM_MXC_NAND in arch/arm/mach-imx/Kconfig but not imx53.

In a custom board BSP, I found an mxc_nd2.c besides mxc_nand.c but not
in mainline. Are there any plans here?

But maybe I just missed sth. - a hint or link would be very much
appreciated.

Thanks in advance,

Roland
