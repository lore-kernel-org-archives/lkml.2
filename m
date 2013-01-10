Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751734Ab3AJKH0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 05:07:26 -0500
Received: from mail-ia0-f179.google.com ([209.85.210.179]:54664 "EHLO
	mail-ia0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130Ab3AJKHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 05:07:24 -0500
MIME-Version: 1.0
In-Reply-To: <50E162F8.8030403@ti.com>
References: <1356358796.1688.3.camel@cliu38-desktop-build>
	<50E162F8.8030403@ti.com>
Date: Thu, 10 Jan 2013 04:07:21 -0600
Message-ID: <CAJ6Av5N0gX5VjARNX=GqVGM-xOv_bW7i0Lh7cz6MhX4+1CYi1A@mail.gmail.com>
Subject: Re: [PATCH] mfd, TWL4030: TWL4030 need select REGMAP_I2C
From: Omar Ramirez Luna <omar.ramirez@copitl.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Chuansheng Liu <chuansheng.liu@intel.com>, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Dec 31, 2012 at 4:03 AM, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:
> On 12/24/2012 03:19 PM, Chuansheng Liu wrote:
>> This patch fix the below build error:
>> drivers/built-in.o: In function `twl_probe':
>> drivers/mfd/twl-core.c:1256: undefined reference to `devm_regmap_init_i2c'
>> make: *** [vmlinux] Error 1
>
> Thanks Liu, I have missed this one.
>
> Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

Mind taking mine, it was sent before this one :)

https://patchwork.kernel.org/patch/1908991/

Cheers,

Omar
