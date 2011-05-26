Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932584Ab1EZAPU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 20:15:20 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:45351 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753256Ab1EZAPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 20:15:19 -0400
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "'Alexander Stein'" <alexander.stein@systec-electronic.com>
Cc: "'Grant Likely'" <grant.likely@secretlab.ca>,
        <linux-kernel@vger.kernel.org>, <qi.wang@intel.com>,
        <yong.y.wang@intel.com>, <joel.clark@intel.com>,
        <kok.howg.ewe@intel.com>, <toshiharu-linux@dsn.okisemi.com>,
        "'Fan, Yongning'" <yongning.fan@intel.com>
References: <1305600395-7192-1-git-send-email-tomoya-linux@dsn.okisemi.com> <201105241745.08302.alexander.stein@systec-electronic.com> <1A7613A496994F5AA69F0142CFDF892B@hacdom.okisemi.com> <201105251403.58051.alexander.stein@systec-electronic.com>
Subject: RE: [PATCH] pch_gpio: support interrupt function
Date: Thu, 26 May 2011 09:15:15 +0900
Message-ID: <2FD9FC48DF7C49C09CD67A5025D5D12A@hacdom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
Thread-Index: Acwa09Yjj/c08OOGQHSOTBIxf3uEmgAZWl/w
In-Reply-To: <201105251403.58051.alexander.stein@systec-electronic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexander 

> "genirq: Remove compat code" get_irq_chip_data and friends 
You are right.
In 2.6.39, get_irq_chip_data and friends look deleted.

Modifying for 2.6.39, I will post again.

Thanks,
-----------------------------------------
Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.

> -----Original Message-----
> From: Alexander Stein [mailto:alexander.stein@systec-electronic.com] 
> Sent: Wednesday, May 25, 2011 9:04 PM
> To: Tomoya MORINAGA
> Cc: 'Grant Likely'; linux-kernel@vger.kernel.org; 
> qi.wang@intel.com; yong.y.wang@intel.com; 
> joel.clark@intel.com; kok.howg.ewe@intel.com; 
> toshiharu-linux@dsn.okisemi.com
> Subject: Re: [PATCH] pch_gpio: support interrupt function
> 
> Hello Tomoya,
> 
> On Wednesday 25 May 2011 02:03:54 Tomoya MORINAGA wrote:
> > > This patch doesn't apply to v2.6.39. There are some more or less 
> > > trivial fixes needed. But it doesn't compile anyway.
> > 
> > I want to update your indications to our driver.
> > Would you show it ?
> 
> These are my compilation messages:
>   CC      drivers/gpio/pch_gpio.o
> drivers/gpio/pch_gpio.c: In function 'pch_irq_type':
> drivers/gpio/pch_gpio.c:195:9: error: implicit declaration of 
> function 'get_irq_chip_data'
> drivers/gpio/pch_gpio.c:195:26: warning: initialization makes 
> pointer from integer without a cast
> drivers/gpio/pch_gpio.c: At top level:
> drivers/gpio/pch_gpio.c:256:2: error: unknown field 'mask' 
> specified in initializer
> drivers/gpio/pch_gpio.c:256:2: warning: initialization from 
> incompatible pointer type
> drivers/gpio/pch_gpio.c:257:2: error: unknown field 'unmask' 
> specified in initializer
> drivers/gpio/pch_gpio.c:257:2: warning: initialization from 
> incompatible pointer type
> drivers/gpio/pch_gpio.c:258:2: error: unknown field 
> 'set_type' specified in initializer
> drivers/gpio/pch_gpio.c:258:2: warning: initialization from 
> incompatible pointer type
> drivers/gpio/pch_gpio.c: In function 'pch_gpio_probe':
> drivers/gpio/pch_gpio.c:339:3: error: implicit declaration of 
> function 'set_irq_chip_and_handler_name'
> drivers/gpio/pch_gpio.c:341:3: error: implicit declaration of 
> function 'set_irq_chip_data'
> 
> If you need/want the actual patch I can mail it.
> It seems starting with commit 0c6f8a8b917ad361319c8ace3e9f28e69bfdb4c1
> "genirq: Remove compat code" get_irq_chip_data and friends 
> are removed.
> 
> Regards,
> Alexander
> 

