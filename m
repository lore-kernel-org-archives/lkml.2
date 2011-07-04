Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758296Ab1GDQ30 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 12:29:26 -0400
Received: from www.linutronix.de ([62.245.132.108]:43607 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757269Ab1GDQ3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 12:29:25 -0400
Message-ID: <4E11EA63.8010909@linutronix.de>
Date: Mon, 04 Jul 2011 18:29:23 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-kernel@vger.kernel.org, sodaville@linutronix.de
Subject: Re: [PATCH v2 2/2] gpio: Add a driver for Sodaville GPIO controller
References: <1309159583-11339-1-git-send-email-bigeasy@linutronix.de> <1309159583-11339-2-git-send-email-bigeasy@linutronix.de> <20110704161914.GH29977@ponder.secretlab.ca>
In-Reply-To: <20110704161914.GH29977@ponder.secretlab.ca>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Likely wrote:
> 
> I tried to apply this, but it failed to build:
> 
> /home/grant/hacking/linux-2.6/drivers/gpio/gpio-sodaville.c: In
> function ‘sdv_xlate’:
> /home/grant/hacking/linux-2.6/drivers/gpio/gpio-sodaville.c:106:15:
> error: ‘struct irq_domain’ has no member named ‘of_node’

> I assume there is a missing #include, you can either send a fixup
> patch or a new version, your choice.

I guess you have to ask the DT maintainer which merged the irq_domain
thingy to create a topic branch for you :)

> Also...
> 
>> diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
>> index 0fbdd75..cc6d662 100644
>> --- a/drivers/gpio/Makefile
>> +++ b/drivers/gpio/Makefile
>> @@ -41,6 +41,7 @@ obj-$(CONFIG_GPIO_S5PV210)	+= gpio-s5pv210.o
>>  
>>  obj-$(CONFIG_GPIO_SCH)		+= gpio-sch.o
>>  obj-$(CONFIG_GPIO_STMPE)	+= gpio-stmpe.o
>> +obj-$(CONFIG_GPIO_SODAVILLE)	+= gpio-sodaville.o
>>  obj-$(CONFIG_GPIO_SX150X)	+= gpio-sx150x.o
>>  obj-$(CONFIG_GPIO_TC3589X)	+= gpio-tc3589x.o
>>  obj-$(CONFIG_ARCH_TEGRA)	+= gpio-tegra.o
> 
> Last I checked, SO comes before ST in alphabetized lists.  :-)

Ah, we use the standardized one. Is it okay to send an incremental patch
for that once it compiles?

> g.

Sebastian
