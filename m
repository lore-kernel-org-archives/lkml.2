Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127Ab1KWUuI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 15:50:08 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:2399 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754822Ab1KWUuH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 15:50:07 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 23 Nov 2011 12:50:05 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Denis Kuzmenko <linux@solonet.org.ua>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Richard Purdie <rpurdie@rpsys.net>,
        Wolfram Sang <w.sang@pengutronix.de>
Date: Wed, 23 Nov 2011 12:50:01 -0800
Subject: RE: [PATCH v3] s3c/s3c24xx: arm: leds: Make s3c24xx LEDS driver use
 gpiolib
Thread-Topic: [PATCH v3] s3c/s3c24xx: arm: leds: Make s3c24xx LEDS driver
 use gpiolib
Thread-Index: Acyo7DN2sKUka4JFSQi7RjZdw2mWMwBNTVTQ
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF174F08C7DD@HQMAIL01.nvidia.com>
References: <4ECB561A.5080204@solonet.org.ua>
In-Reply-To: <4ECB561A.5080204@solonet.org.ua>
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

Denis Kuzmenko wrote at Tuesday, November 22, 2011 12:58 AM:
> Make s3c24xx LEDS driver use gpiolib. Fix error disabling pull during probe.
> 
> Signed-off-by: Denis Kuzmenko <linux@solonet.org.ua>

Acked-by: Stephen Warren <swarren@nvidia.com>

-- 
nvpublic

