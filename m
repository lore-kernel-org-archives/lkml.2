Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758247Ab2B2SEF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 13:04:05 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10632 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756745Ab2B2SED convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 13:04:03 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 29 Feb 2012 10:03:59 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: Grant Likely <grant.likely@secretlab.ca>, Barry Song <21cnbao@gmail.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Linus Walleij <linus.walleij@linaro.org>
Date: Wed, 29 Feb 2012 10:03:57 -0800
Subject: RE: [PATCH v2] pinctrl: make the pinmux-pins more helpful
Thread-Topic: [PATCH v2] pinctrl: make the pinmux-pins more helpful
Thread-Index: Acz3C94yHuXqy1MpSq+gr6T+qoO9lAAAIWow
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17BDDF20C2@HQMAIL01.nvidia.com>
References: <1330538332-16088-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1330538332-16088-1-git-send-email-linus.walleij@stericsson.com>
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

Linus Walleij wrote at Wednesday, February 29, 2012 10:59 AM:
> The debugfs file pinmux-pins used to tell which function was
> enabled but now states simply which device owns the pin. Being
> owned by the pinctrl driver itself means just that it's hogged
> so be a bit more helpful by printing that.
> 
> ChangeLog v1->v2:
> - Preserve the self-referential owner field, just clarify that
>   when the pin controller states itself as owner this means
>   that it's hogged.
> 
> Acked-by: Dong Aisheng <dong.aisheng@linaro.org>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Exactly what I want, thanks.

Acked-by: Stephen Warren <swarren@nvidia.com>

-- 
nvpublic

