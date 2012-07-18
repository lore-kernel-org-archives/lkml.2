Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421Ab2GRMxr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 08:53:47 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5529 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723Ab2GRMxo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 08:53:44 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 18 Jul 2012 05:53:43 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Joonyoung Shim <dofmind@gmail.com>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 18 Jul 2012 18:23:36 +0530
Subject: RE: Question about tps65090 mfd driver
Thread-Topic: Question about tps65090 mfd driver
Thread-Index: Ac1k4wQSrNEI7L5kROyPL/63C6UITwAAHVxw
Message-ID: <D958900912E20642BCBC71664EFECE3E6DDB1D6B26@BGMAIL02.nvidia.com>
References: <CAPLVkLshQjOne9BtZYkth0uZ6ABjYHZ85M2ETKd-D0TRkt+QQw@mail.gmail.com>
In-Reply-To: <CAPLVkLshQjOne9BtZYkth0uZ6ABjYHZ85M2ETKd-D0TRkt+QQw@mail.gmail.com>
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

Yes, you are right.
it was a mistake.
Will send a patch soon.

Thanks,
Venu


> -----Original Message-----
> From: Joonyoung Shim [mailto:dofmind@gmail.com]
> Sent: Wednesday, July 18, 2012 6:14 PM
> To: Venu Byravarasu
> Cc: sameo@linux.intel.com; linux-kernel@vger.kernel.org
> Subject: Question about tps65090 mfd driver
> 
> Hi,
> 
> I have one question about tps65090 mfd driver.
> There are following codes in the drivers/mfd/tps65090.c
> 
> ...
> static struct mfd_cell tps65090s[] = {
> 	{
> 		.name = "tps65910-pmic",
> 	},
> 	{
> 		.name = "tps65910-regulator",
> 	},
> };
> ...
> 
> I know tps65090 and tps65910 have each different regulator driver.
> 
> drivers/regulator/tps65090-regulator.c
> drivers/regulator/tps65910-regulator.c
> 
> So, i wonder whether it is right that tps65090 mfd driver has tps65910-xxx.
> 
> Thanks.
> 
> --
> - Joonyoung Shim
