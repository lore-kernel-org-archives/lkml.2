Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932866Ab2CZPgc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 11:36:32 -0400
Received: from mail.meprolight.com ([194.90.149.17]:29385 "EHLO meprolight.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932722Ab2CZPgb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 11:36:31 -0400
From: Alex Gershgorin <alexg@meprolight.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "marc.reilly@gmail.com" <marc.reilly@gmail.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "fabio.estevam@freescale.com" <fabio.estevam@freescale.com>
Date: Mon, 26 Mar 2012 17:36:01 +0200
Subject: RE: [PATCH] mfd: mc13xxx: add I2C support fix building v3.3
Thread-Topic: [PATCH] mfd: mc13xxx: add I2C support fix building v3.3
Thread-Index: Ac0LX26/qt9lBKp4RwagDRkAytv7ywABeWS2
Message-ID: <4875438356E7CA4A8F2145FCD3E61C0B2CC34CAD17@MEP-EXCH.meprolight.com>
References: <1332772370-13272-1-git-send-email-alexg@meprolight.com>,<20120326144804.GU3098@opensource.wolfsonmicro.com>
In-Reply-To: <20120326144804.GU3098@opensource.wolfsonmicro.com>
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


 
>>Subject: Re: [PATCH] mfd: mc13xxx: add I2C support fix building v3.3

On Mon, Mar 26, 2012 at 04:32:50PM +0200, Alex Gershgorin wrote:
> This patch fixes the compilation errors after the patches
> from series mc13xxx-add-I2C-support-V4 were applied.
> It was successfully tested on i.MX35 PDK  v3.3

>> Nack, please submit any required changes properly.

Do you mean, that this patch should be divided into two patches ?

Thanks 
Alex Gershgorin
