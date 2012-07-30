Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657Ab2G3GBN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 02:01:13 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13945 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929Ab2G3GBL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 02:01:11 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Sun, 29 Jul 2012 23:01:11 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Fengguang Wu <fengguang.wu@intel.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, Axel Lin <axel.lin@gmail.com>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 30 Jul 2012 11:31:04 +0530
Subject: RE: drivers/mfd/tps65090.c: duplicated TPS65090_INT_STS tests
Thread-Topic: drivers/mfd/tps65090.c: duplicated TPS65090_INT_STS tests
Thread-Index: Ac1svWP/0tyxqSc7S1qqlWIWJAS7qgBW0MnA
Message-ID: <D958900912E20642BCBC71664EFECE3E6DDCAC418E@BGMAIL02.nvidia.com>
References: <20120728123441.GB11202@localhost>
In-Reply-To: <20120728123441.GB11202@localhost>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for catching typo.
Plz push a patch with fix.

Thanks,
Venu


> -----Original Message-----
> From: Fengguang Wu [mailto:fengguang.wu@intel.com]
> Sent: Saturday, July 28, 2012 6:05 PM
> To: Venu Byravarasu
> Cc: Samuel Ortiz; Axel Lin; kernel-janitors@vger.kernel.org; LKML
> Subject: drivers/mfd/tps65090.c: duplicated TPS65090_INT_STS tests
> 
> Hi Venu,
> 
> Is this coccinelle warning a trivial one, or indicates some copy&paste
> error? It's introduced by commit 3c33be06 ("mfd: Add support for
> TPS65090").
> 
> drivers/mfd/tps65090.c:239:5-30: duplicated argument to && or ||
> 
> vim +239 drivers/mfd/tps65090.c
>    236
>    237	static bool is_volatile_reg(struct device *dev, unsigned int reg)
>    238	{
>  > 239		if ((reg == TPS65090_INT_STS) || (reg == TPS65090_INT_STS))
>    240			return true;
>    241		else
>    242			return false;
> 
> ---
> 0-DAY kernel build testing backend         Open Source Technology Centre
> Fengguang Wu <wfg@linux.intel.com>                     Intel Corporation
