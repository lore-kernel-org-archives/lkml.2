Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933016Ab2CZRad (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 13:30:33 -0400
Received: from mail.meprolight.com ([194.90.149.17]:32365 "EHLO meprolight.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932649Ab2CZRac convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 13:30:32 -0400
From: Alex Gershgorin <alexg@meprolight.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "marc.reilly@gmail.com" <marc.reilly@gmail.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "fabio.estevam@freescale.com" <fabio.estevam@freescale.com>
Date: Mon, 26 Mar 2012 19:30:05 +0200
Subject: RE: [PATCH] regmap: Add 24 bits support
Thread-Topic: [PATCH] regmap: Add 24 bits support
Thread-Index: Ac0LX9RReoYjeaUJRqGSo1B4t4AHcAAE/7BG
Message-ID: <4875438356E7CA4A8F2145FCD3E61C0B2CC34CAD1C@MEP-EXCH.meprolight.com>
References: <1332772808-13346-1-git-send-email-alexg@meprolight.com>,<20120326145054.GV3098@opensource.wolfsonmicro.com>
In-Reply-To: <20120326145054.GV3098@opensource.wolfsonmicro.com>
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


 
>Subject: Re: [PATCH] regmap: Add 24 bits support

On Mon, Mar 26, 2012 at 04:40:08PM +0200, Alex Gershgorin wrote:
> This patch adds support for PMIC who use regmap and 24 bit registers
> For example MC13892, the patch was tested on i.MX35-PDK

> >A similar patch from Marc Reilly has already been applied.  You don't
> >have his signoff here but then...

Sorry Marc, I missed the patch 

> +typedef struct { __u8 b[3]; } __be24;

> > ...you're adding stuff like this to the regmap headers which *clearly*
> > isn't regmap specific so this looks like a separate development.

You right,

I think it makes no sense to fix it,
why do we need two similar patches

Thanks  
