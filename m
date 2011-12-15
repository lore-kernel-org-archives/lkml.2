Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759102Ab1LOQWM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 11:22:12 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4189 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758987Ab1LOQWL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 11:22:11 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 15 Dec 2011 08:22:06 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Grant Likely <grant.likely@secretlab.ca>, Barry Song <21cnbao@gmail.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Linus Walleij <linus.walleij@linaro.org>
Date: Thu, 15 Dec 2011 08:22:05 -0800
Subject: RE: [PATCH] pinctrl: conjure names for unnamed pins
Thread-Topic: [PATCH] pinctrl: conjure names for unnamed pins
Thread-Index: Acy6l4deMFPRgczVSFad7a1PJ4ZTZwArfX1w
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF176BE922A4@HQMAIL01.nvidia.com>
References: <1323891299-31333-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1323891299-31333-1-git-send-email-linus.walleij@stericsson.com>
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

Linus Walleij wrote at Wednesday, December 14, 2011 12:35 PM:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> If pins with blank names are registered, we assign them names on-the-fly
> on the form "PINn" where n is the pin number for that pin on the specific
> controller.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Acked-by: Stephen Warren <swarren@nvidia.com>

That could be a lot of dynamic allocations, but since the individual
drivers are in control of whether any are needed (i.e. they can provide
names themselves), this seems fine - it doesn't affect anything that
doesn't want the feature.

-- 
nvpublic

