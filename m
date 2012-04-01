Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751465Ab2DALNO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 07:13:14 -0400
Received: from mail.meprolight.com ([194.90.149.17]:28690 "EHLO meprolight.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750897Ab2DALNL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 07:13:11 -0400
From: Alex Gershgorin <alexg@meprolight.com>
To: Marc Reilly <marc@cpdesign.com.au>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "u.kleine-koenig@pengutronix.de" <u.kleine-koenig@pengutronix.de>,
        "oskar@scara.com" <oskar@scara.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sun, 1 Apr 2012 14:12:32 +0300
Subject: RE: mc13xxx: add I2C support, V5
Thread-Topic: mc13xxx: add I2C support, V5
Thread-Index: Ac0P2kp6szD/u/3eRQ6cAglcWrpukgAGwYWe
Message-ID: <4875438356E7CA4A8F2145FCD3E61C0B2CC34CAD2A@MEP-EXCH.meprolight.com>
References: <1333262499-25871-1-git-send-email-marc@cpdesign.com.au>
In-Reply-To: <1333262499-25871-1-git-send-email-marc@cpdesign.com.au>
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

Hi Marc, thanks for V5.

> This series (against mfd-2.6/for-next) changes the mc13xxx driver to use
> regmap and adds I2C support.
> It has a compile dependency on regmap/for-next, as the spi driver uses the
> recently added pad_bits config field.

If included in your plans to relocate the current version of patches for version 3.4?

Cheers,
Alex


