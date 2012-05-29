Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461Ab2E2HiZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 03:38:25 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52710 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341Ab2E2HiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 03:38:23 -0400
Message-ID: <4FC47CEB.8090106@linaro.org>
Date: Tue, 29 May 2012 15:38:19 +0800
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] mfd: Remove config AB8500_I2C_CORE Kconfig entry
References: <1338272340.3127.1.camel@phoenix>
In-Reply-To: <1338272340.3127.1.camel@phoenix>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/05/12 14:19, Axel Lin wrote:
> config AB8500_I2C_CORE is not used after commit d28f1db
> "mfd: Remove confusing ab8500-i2c file and merge into ab8500-core".
> Thus remove it.
>
> Signed-off-by: Axel Lin<axel.lin@gmail.com>

I have this patch embedded into a patch-set I'm going to send to ARM-SoC 
for inclusion into -rc1 this afternoon. Would you mind leaving this one?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
