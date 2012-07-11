Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518Ab2GKMa1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 08:30:27 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19728 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174Ab2GKMa0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 08:30:26 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 11 Jul 2012 05:26:37 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Sangbeom Kim <sbkim73@samsung.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>
CC: "'Liam Girdwood'" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sbkim01@gmail.com" <sbkim01@gmail.com>
Date: Wed, 11 Jul 2012 18:00:20 +0530
Subject: RE: [PATCH V3 3/7] mfd: samsung: Modify samsung mfd header
Thread-Topic: [PATCH V3 3/7] mfd: samsung: Modify samsung mfd header
Thread-Index: Ac1fXbbieHH+gCiiTPG5j4NYs10mVAAAYpkg
Message-ID: <D958900912E20642BCBC71664EFECE3E6DDB1D61AC@BGMAIL02.nvidia.com>
References: <012b01cd5f5d$b6ff8a10$24fe9e30$@com>
In-Reply-To: <012b01cd5f5d$b6ff8a10$24fe9e30$@com>
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

> --- /dev/null
> +++ b/include/linux/mfd/samsung/core.h
> @@ -0,0 +1,147 @@
> +/*
> + * core.h
> + *
> + * copyright (c) 2011 Samsung Electronics Co., Ltd
> + *              http://www.samsung.com

In most of the files you mentioned 2011.
Should they not be changed to 2012?

> + *
> + *  This program is free software; you can redistribute  it and/or modify it
> + *  under  the terms of  the GNU General  Public License as published by the
> + *  Free Software Foundation;  either version 2 of the  License, or (at your
> + *  option) any later version.




> -
> -#ifndef __LINUX_MFD_S5M_CORE_H
> -#define __LINUX_MFD_S5M_CORE_H
> -
> -
> -	int				buck_set1;
> -	int				buck_set2;
> -	int				buck_set3;

As you have buck4_enable etc below, by any chance do you need buck_set4 as well here?
Similarly should you declare buck1_enable here?

> -	int				buck2_enable;
> -	int				buck3_enable;
> -	int				buck4_enable;
> -	int				buck_default_idx;
> -	int				buck2_default_idx;


