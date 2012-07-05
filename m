Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932689Ab2GENOG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 09:14:06 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52030 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932339Ab2GENOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 09:14:03 -0400
Message-ID: <4FF59315.2040105@linaro.org>
Date: Thu, 05 Jul 2012 14:13:57 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Fabio Estevam <festevam@gmail.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de, sameo@linux.intel.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 1/1] mfd: Fix runtime warning caused by duplicate device
 registration
References: <1341316788-12730-1-git-send-email-lee.jones@linaro.org> <CAOMZO5BQuJzAYPe+B792aNYv+xew3O0wp-UOjwggV28MbSZr9w@mail.gmail.com>
In-Reply-To: <CAOMZO5BQuJzAYPe+B792aNYv+xew3O0wp-UOjwggV28MbSZr9w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fabio,

> On Tue, Jul 3, 2012 at 8:59 AM, Lee Jones <lee.jones@linaro.org> wrote:
>> We register the ab8500 as an MFD device from db8500 code during Device Tree
>> boot in order to solve some limitations of DT. However, when Device Tree is
>> not enabled, we still want to allow platform code to register the ab8500 in
>> the normal way. Here we force MFD device registration of the ab8500 only
>> when booting with Device Tree enabled.
>>
>> Solves this issue:
>> WARNING: at fs/sysfs/dir.c:526 sysfs_add_one+0x88/0xb0()
>> sysfs: cannot create duplicate filename '/bus/platform/devices/ab8500-core.0'
>
> Does the following patch fix your issue?
> http://www.spinics.net/lists/arm-kernel/msg182827.html

No, it's unrelated.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog


