Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801Ab1KQRRR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 12:17:17 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:14506 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754292Ab1KQRRQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 12:17:16 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 17 Nov 2011 09:17:12 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Grant Likely <grant.likely@secretlab.ca>, Barry Song <21cnbao@gmail.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Date: Thu, 17 Nov 2011 09:17:11 -0800
Subject: RE: [PATCH v2] pinctrl: indicate GPIO direction on single GPIO
 request
Thread-Topic: [PATCH v2] pinctrl: indicate GPIO direction on single GPIO
 request
Thread-Index: AcylL1YVe90bPW6QRniHIM6GxSKbJwAHSbFg
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1740D74BC4@HQMAIL01.nvidia.com>
References: <1321537582-8624-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1321537582-8624-1-git-send-email-linus.walleij@stericsson.com>
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

Linus Walleij wrote at Thursday, November 17, 2011 6:46 AM:
> When requesting a single GPIO pin to be muxed in, some controllers
> will need to poke a different value into the control register
> depending on whether the pin will be used for GPIO output or GPIO
> input. So pass this info along for the gpio_request_enable()
> function, we assume this is not needed for the gpio_free_disable()
> function for the time being.

My most recent comments in the thread following the previous patch re:
the need to expand the set of required pinctrl GPIO-related functions
apply to this patch.

-- 
nvpublic

