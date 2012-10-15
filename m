Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572Ab2JOIcz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 04:32:55 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:37789 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237Ab2JOIcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 04:32:53 -0400
MIME-Version: 1.0
In-Reply-To: <506CCAB9.4070402@xenotime.net>
References: <20121003173007.c322d79c31676b9494a6bfd5@canb.auug.org.au>
	<506CCAB9.4070402@xenotime.net>
Date: Mon, 15 Oct 2012 16:32:53 +0800
Message-ID: <CAP1dx+yw93nUPozq8kcmQKtmHm5K+qMvEPQatn6Km1pHOC5dbw@mail.gmail.com>
Subject: Re: linux-next: Tree for Oct 3 (mfd/syscon)
From: Dong Aisheng <dong.aisheng@linaro.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

On 4 October 2012 07:31, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On 10/03/2012 12:30 AM, Stephen Rothwell wrote:
>
>> Hi all,
>>
>> Do not add stuff destined for v3.8 to your linux-next included branches
>> until after v3.7-rc1 is released.
>>
>> Changes since 201201002:
>>
>
>
> on i386:
>
>   CC      drivers/mfd/syscon.o
> drivers/mfd/syscon.c:94:15: error: variable 'syscon_regmap_config' has initializer but incomplete type
> drivers/mfd/syscon.c:95:2: error: unknown field 'reg_bits' specified in initializer
> drivers/mfd/syscon.c:95:2: warning: excess elements in struct initializer
> drivers/mfd/syscon.c:95:2: warning: (near initialization for 'syscon_regmap_config')
> drivers/mfd/syscon.c:96:2: error: unknown field 'val_bits' specified in initializer
> drivers/mfd/syscon.c:96:2: warning: excess elements in struct initializer
> drivers/mfd/syscon.c:96:2: warning: (near initialization for 'syscon_regmap_config')
> drivers/mfd/syscon.c:97:2: error: unknown field 'reg_stride' specified in initializer
> drivers/mfd/syscon.c:97:2: warning: excess elements in struct initializer
> drivers/mfd/syscon.c:97:2: warning: (near initialization for 'syscon_regmap_config')
> drivers/mfd/syscon.c: In function 'syscon_probe':
> drivers/mfd/syscon.c:124:2: error: invalid use of undefined type 'struct regmap_config'
> drivers/mfd/syscon.c:125:2: error: implicit declaration of function 'devm_regmap_init_mmio'
> drivers/mfd/syscon.c:125:17: warning: assignment makes pointer from integer without a cast
> make[3]: *** [drivers/mfd/syscon.o] Error 1
>
>
> Full randconfig file is attached.
>
I sent out the fix patch with you CC-ed.

Regards
Dong Aisheng
