Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529Ab1EYMEB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 08:04:01 -0400
Received: from webbox687.server-home.net ([195.149.74.151]:58097 "EHLO
	webbox687.server-home.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754675Ab1EYMEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 08:04:00 -0400
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
Subject: Re: [PATCH] pch_gpio: support interrupt function
Date: Wed, 25 May 2011 14:03:56 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.38-gentoo-r2; KDE/4.6.2; x86_64; ; )
Cc: "'Grant Likely'" <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com
References: <1305600395-7192-1-git-send-email-tomoya-linux@dsn.okisemi.com> <201105241745.08302.alexander.stein@systec-electronic.com> <1A7613A496994F5AA69F0142CFDF892B@hacdom.okisemi.com>
In-Reply-To: <1A7613A496994F5AA69F0142CFDF892B@hacdom.okisemi.com>
MIME-Version: 1.0
X-Length: 5004
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105251403.58051.alexander.stein@systec-electronic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Tomoya,

On Wednesday 25 May 2011 02:03:54 Tomoya MORINAGA wrote:
> > This patch doesn't apply to v2.6.39. There are some more or
> > less trivial fixes needed. But it doesn't compile anyway.
> 
> I want to update your indications to our driver.
> Would you show it ?

These are my compilation messages:
  CC      drivers/gpio/pch_gpio.o
drivers/gpio/pch_gpio.c: In function 'pch_irq_type':
drivers/gpio/pch_gpio.c:195:9: error: implicit declaration of function 
'get_irq_chip_data'
drivers/gpio/pch_gpio.c:195:26: warning: initialization makes pointer from 
integer without a cast
drivers/gpio/pch_gpio.c: At top level:
drivers/gpio/pch_gpio.c:256:2: error: unknown field 'mask' specified in 
initializer
drivers/gpio/pch_gpio.c:256:2: warning: initialization from incompatible 
pointer type
drivers/gpio/pch_gpio.c:257:2: error: unknown field 'unmask' specified in 
initializer
drivers/gpio/pch_gpio.c:257:2: warning: initialization from incompatible 
pointer type
drivers/gpio/pch_gpio.c:258:2: error: unknown field 'set_type' specified in 
initializer
drivers/gpio/pch_gpio.c:258:2: warning: initialization from incompatible 
pointer type
drivers/gpio/pch_gpio.c: In function 'pch_gpio_probe':
drivers/gpio/pch_gpio.c:339:3: error: implicit declaration of function 
'set_irq_chip_and_handler_name'
drivers/gpio/pch_gpio.c:341:3: error: implicit declaration of function 
'set_irq_chip_data'

If you need/want the actual patch I can mail it.
It seems starting with commit 0c6f8a8b917ad361319c8ace3e9f28e69bfdb4c1 
"genirq: Remove compat code" get_irq_chip_data and friends are removed.

Regards,
Alexander
