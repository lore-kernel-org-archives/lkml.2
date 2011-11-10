Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935480Ab1KJP6q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 10:58:46 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1604 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932801Ab1KJP6p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 10:58:45 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 10 Nov 2011 07:58:40 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Grant Likely <grant.likely@secretlab.ca>, Barry Song <21cnbao@gmail.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Linus Walleij <linus.walleij@linaro.org>
Date: Thu, 10 Nov 2011 07:58:39 -0800
Subject: RE: [PATCH] pinctrl: documentation update
Thread-Topic: [PATCH] pinctrl: documentation update
Thread-Index: AcyfgwXHxG2SDJw/T56MiMpP+G4QoAAPm3Jg
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1740805401@HQMAIL01.nvidia.com>
References: <1320913807-19928-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1320913807-19928-1-git-send-email-linus.walleij@stericsson.com>
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

Linus Walleij wrote at Thursday, November 10, 2011 1:30 AM:
> Update the docs removing an obsolete __refdata tag and document
> the mysterious return value of pin_free().
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Once the typo I mention below is fixed,
Acked-by: Stephen Warren <swarren@nvidia.com>

...
> + * for callers that dynamically allocate a function name so it can be free:ed

s/free:ed/freed/ I think?

-- 
nvpublic

