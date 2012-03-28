Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757992Ab2C1Nsc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 09:48:32 -0400
Received: from mail.meprolight.com ([194.90.149.17]:49714 "EHLO meprolight.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757857Ab2C1Nsa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 09:48:30 -0400
From: Alex Gershgorin <alexg@meprolight.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "marc.reilly@gmail.com" <marc.reilly@gmail.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "fabio.estevam@freescale.com" <fabio.estevam@freescale.com>
Date: Wed, 28 Mar 2012 15:48:02 +0200
Subject: RE: [PATCH v1] mfd: mc13xxx: add I2C support fix building for v3.3
Thread-Topic: [PATCH v1] mfd: mc13xxx: add I2C support fix building for v3.3
Thread-Index: Ac0M5yfo7f76SVrtTuevUGQXl/rIsQAAOt6+
Message-ID: <4875438356E7CA4A8F2145FCD3E61C0B2CC34CAD23@MEP-EXCH.meprolight.com>
References: <1332846260-18145-1-git-send-email-alexg@meprolight.com>,<20120328133220.GR3232@opensource.wolfsonmicro.com>
In-Reply-To: <20120328133220.GR3232@opensource.wolfsonmicro.com>
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

Hi Mark,

> This patch fixes the following compilation errors,
> when using a series mc13xxx-add-I2C-support-V4

> 1)
> drivers/mfd/mc13xxx-spi.c:50: error: unknown field 'pad_bits'
> specified in initializer

> >This (and probably some of the other stuff) is already merged.  Is this
> > just a backport of stuff for 3.4/5 to enable testing on 3.3 or are there
> >any errors that need to be fixed in the relevant places?

Yes, you're right for v3.4 is not need.
I'll send a patch for v3.4 

Regards
Alex Gershgorin