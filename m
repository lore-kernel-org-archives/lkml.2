Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937Ab0IPTRF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 15:17:05 -0400
Received: from be1ssnxpe2.nxp.com ([57.67.164.70]:35669 "EHLO
	be1ssnxpe2.nxp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733Ab0IPTRD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 15:17:03 -0400
From: Kevin Wells <kevin.wells@nxp.com>
To: Linus Walleij <linus.walleij@stericsson.com>
CC: Kevin Wells <wellsk40@gmail.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "rabin.vincent@stericsson.com" <rabin.vincent@stericsson.com>,
        "srinidhi.kasagar@stericsson.com" <srinidhi.kasagar@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "u.kleine-koenig@pengutronix.de" <u.kleine-koenig@pengutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "tj@kernel.org" <tj@kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "Lukasz.Baj@tieto.com" <Lukasz.Baj@tieto.com>
Date: Thu, 16 Sep 2010 21:16:08 +0200
Subject: RE: resend: [PATCH] amba_pl022: Setup SPI configuration based on
 spi->mode
Thread-Topic: resend: [PATCH] amba_pl022: Setup SPI configuration based on
 spi->mode
Thread-Index: ActUG4wpmO+rQ/2xTJmVIZ5LSUmnZQBt+FEQ
Message-ID: <083DF309106F364B939360100EC290F80AF398DEE4@eu1rdcrdc1wx030.exi.nxp.com>
References: <AANLkTikbKwo9=xLWo1qEcc2E5aa2iN2F_KCokJPpnWOk@mail.gmail.com>
	<083DF309106F364B939360100EC290F80AD49D5230@eu1rdcrdc1wx030.exi.nxp.com>
 <AANLkTim4a7eha6Z3pjrZ0kg9VNRcuH52Qs2h4XydsXi4@mail.gmail.com>
In-Reply-To: <AANLkTim4a7eha6Z3pjrZ0kg9VNRcuH52Qs2h4XydsXi4@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.0.10011,1.0.148,0.0.0000 definitions=2010-09-16_11:2010-09-16,2010-09-16,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> With this correction it starts working, so
> Acked-by/Tested-by/Reviewed-by: Linus Walleij
> <linus.walleij@stericsson.com>
> 
> Please submit the whole patch series with corrections and my tag
> so Grant can pick it up, and thanks for doing this because I think
> it is a great improvement to the driver!
> 

Thanks! I'll put them up today.

> Yours,
> Linus Walleij
