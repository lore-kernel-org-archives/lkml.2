Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421Ab2ILT6z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 15:58:55 -0400
Received: from www.linutronix.de ([62.245.132.108]:35262 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab2ILT6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 15:58:54 -0400
Message-ID: <5050E965.5080405@linutronix.de>
Date: Wed, 12 Sep 2012 21:58:29 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.6esrpre) Gecko/20120817 Icedove/10.0.6
MIME-Version: 1.0
To: Cyril Chemparathy <cyril@ti.com>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-c6x-dev@linux-c6x.org,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        linux@openrisc.net, linuxppc-dev@lists.ozlabs.org,
        microblaze-uclinux@itee.uq.edu.au, a-jacquiot@ti.com, arnd@arndb.de,
        benh@kernel.crashing.org, blogic@openwrt.org, david.daney@cavium.com,
        dhowells@redhat.com, grant.likely@secretlab.ca, hpa@zytor.com,
        jonas@southpole.se, linus.walleij@linaro.org, linux@arm.linux.org.uk,
        m.szyprowski@samsung.com, mahesh@linux.vnet.ibm.com, mingo@redhat.com,
        monstr@monstr.eu, msalter@redhat.com, nico@linaro.org,
        paul.gortmaker@windriver.com, paulus@samba.org, ralf@linux-mips.org,
        rob.herring@calxeda.com, suzuki@in.ibm.com, tglx@linutronix.de,
        tj@kernel.org, x86@kernel.org
Subject: Re: [PATCH] of: specify initrd location using 64-bit
References: <1347465937-7056-1-git-send-email-cyril@ti.com> <CAMuHMdUuQzD0bq8PifBea2-0Pk7RhmPA0-GAFprsk+vMxMGjGw@mail.gmail.com> <5050CE33.9060909@ti.com>
In-Reply-To: <5050CE33.9060909@ti.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2012 08:02 PM, Cyril Chemparathy wrote:
>>> -void __init early_init_dt_setup_initrd_arch(unsigned long start,
>>> unsigned long end)
>>> +void __init early_init_dt_setup_initrd_arch(u64 start, u64 end)
>>
>> Why not phys_addr_t?
>>
>
> The rest of the memory specific bits of the device-tree code use u64 for
> addresses, and I kept it the same for consistency.

Geert is right here. If it is a physical address, it should be
phys_addr_t.

Sebastian
