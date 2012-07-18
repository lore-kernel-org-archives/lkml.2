Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab2GRMoF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 08:44:05 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:63194 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198Ab2GRMoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 08:44:01 -0400
MIME-Version: 1.0
Date: Wed, 18 Jul 2012 21:44:00 +0900
Message-ID: <CAPLVkLshQjOne9BtZYkth0uZ6ABjYHZ85M2ETKd-D0TRkt+QQw@mail.gmail.com>
Subject: Question about tps65090 mfd driver
From: Joonyoung Shim <dofmind@gmail.com>
To: vbyravarasu@nvidia.com
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have one question about tps65090 mfd driver.
There are following codes in the drivers/mfd/tps65090.c

...
static struct mfd_cell tps65090s[] = {
	{
		.name = "tps65910-pmic",
	},
	{
		.name = "tps65910-regulator",
	},
};
...

I know tps65090 and tps65910 have each different regulator driver.

drivers/regulator/tps65090-regulator.c
drivers/regulator/tps65910-regulator.c

So, i wonder whether it is right that tps65090 mfd driver has tps65910-xxx.

Thanks.

-- 
- Joonyoung Shim
