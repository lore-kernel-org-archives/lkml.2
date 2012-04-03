Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081Ab2DCPy2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 11:54:28 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:47388 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846Ab2DCPy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 11:54:26 -0400
X-RZG-AUTH: :P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrT1q0ngWNsKR9Dbc7nsXB+5kTfpa/9
X-RZG-CLASS-ID: mo00
Message-ID: <4F7B1D2F.40409@hartkopp.net>
Date: Tue, 03 Apr 2012 17:54:23 +0200
From: Oliver Hartkopp <socketcan@hartkopp.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.3) Gecko/20120327 Icedove/10.0.3
MIME-Version: 1.0
To: "AnilKumar, Chimata" <anilkumar@ti.com>
CC: "m.kleine-budde@pengutronix.de" <m.kleine-budde@pengutronix.de>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Gole, Anant" <anantgole@ti.com>, "Nori, Sekhar" <nsekhar@ti.com>
Subject: Re: [PATCH] ARM: OMAP: AM33XX: CAN: d_can: Add support for Bosch
 D_CAN controller
References: <1333456339-9372-1-git-send-email-anilkumar@ti.com> <331ABD5ECB02734CA317220B2BBEABC1317D84CC@DBDE01.ent.ti.com>
In-Reply-To: <331ABD5ECB02734CA317220B2BBEABC1317D84CC@DBDE01.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03.04.2012 14:39, AnilKumar, Chimata wrote:

> Hi All,
> 
> Subject line of this patch should be
> "ARM: CAN: d_can: Add support for Bosch D_CAN controller"


No, the d_can IP core is generally not limited to ARM.

	"can: Add support for Bosch D_CAN controller"

would be perfectly fine.

The correct way is:

1. post your new CAN driver to linux-can ML
2. When the major reviews & style fixes are done and the driver is fit for
mainline you can post it on ti-omap ML too

But an initial cross-posting of this CAN driver to netdev ML and linux-kernel
ML does not help anyone - it only increases traffic & confusion.

See MAINTAINERS:

http://lxr.linux.no/#linux+v3.3.1/MAINTAINERS#L1710

Thanks for following these hints,
Oliver
