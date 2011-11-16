Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab1KPP5o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 10:57:44 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:17027 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755135Ab1KPP5m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 10:57:42 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 16 Nov 2011 07:57:29 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Wolfram Sang <w.sang@pengutronix.de>,
        Denis Kuzmenko <linux@solonet.org.ua>
CC: Dong Aisheng <dong.aisheng@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 16 Nov 2011 07:57:28 -0800
Subject: RE: [PATCH] gpio: add flags to export GPIOs when requesting
Thread-Topic: [PATCH] gpio: add flags to export GPIOs when requesting
Thread-Index: AcykP5lFdd0H+f4QRseRs/96/DMubwAOKHzQ
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1740D74880@HQMAIL01.nvidia.com>
References: <1321397074-6526-1-git-send-email-w.sang@pengutronix.de>
 <4EC2F035.3060705@solonet.org.ua>
 <74CDBE0F657A3D45AFBB94109FB122FF1740805F1A@HQMAIL01.nvidia.com>
 <4EC371FE.5010402@solonet.org.ua> <20111116091027.GB2596@pengutronix.de>
In-Reply-To: <20111116091027.GB2596@pengutronix.de>
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

Wolfram Sang wrote at Wednesday, November 16, 2011 2:10 AM:
...
> BTW I didn't CC Grant, because he is on sabbatical right now, so Stephen
> you are taking care of GPIO?

No, I believe Linus Walleij is handling GPIO right now. Grant had just
asked for some help with reviews in a few places, so I picked a few things
to look at.

-- 
nvpublic

