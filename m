Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663Ab0LOJEx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 04:04:53 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:51458 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab0LOJEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 04:04:49 -0500
Subject: Re: linux-next: build failure after merge of the voltage tree
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yong Shen <yong.shen@linaro.org>
In-Reply-To: <20101215130911.e6edddfe.sfr@canb.auug.org.au>
References: <20101215130911.e6edddfe.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Dec 2010 09:04:44 +0000
Message-ID: <1292403884.3348.6.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-15 at 13:09 +1100, Stephen Rothwell wrote:
> Hi Liam,
> 
> After merging the voltage tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> drivers/built-in.o: In function `mc13xxx_regulator_is_enabled':
> mc13xxx-regulator-core.c:(.text+0x9b01c): undefined reference to `mc13xxx_lock'
> mc13xxx-regulator-core.c:(.text+0x9b038): undefined reference to `mc13xxx_reg_read'
> mc13xxx-regulator-core.c:(.text+0x9b04a): undefined reference to `mc13xxx_unlock'
> drivers/built-in.o: In function `mc13xxx_regulator_disable':
> mc13xxx-regulator-core.c:(.text+0x9b256): undefined reference to `mc13xxx_lock'
> mc13xxx-regulator-core.c:(.text+0x9b26f): undefined reference to `mc13xxx_reg_rmw'
> mc13xxx-regulator-core.c:(.text+0x9b281): undefined reference to `mc13xxx_unlock'
> drivers/built-in.o: In function `mc13xxx_regulator_enable':
> mc13xxx-regulator-core.c:(.text+0x9b323): undefined reference to `mc13xxx_lock'
> mc13xxx-regulator-core.c:(.text+0x9b33c): undefined reference to `mc13xxx_reg_rmw'
> mc13xxx-regulator-core.c:(.text+0x9b34e): undefined reference to `mc13xxx_unlock'
> drivers/built-in.o: In function `mc13xxx_regulator_get_voltage':
> mc13xxx-regulator-core.c:(.text+0x9b3f5): undefined reference to `mc13xxx_lock'
> mc13xxx-regulator-core.c:(.text+0x9b40c): undefined reference to `mc13xxx_reg_read'
> mc13xxx-regulator-core.c:(.text+0x9b41f): undefined reference to `mc13xxx_unlock'
> drivers/built-in.o: In function `mc13xxx_regulator_set_voltage':
> mc13xxx-regulator-core.c:(.text+0x9b67f): undefined reference to `mc13xxx_lock'
> mc13xxx-regulator-core.c:(.text+0x9b6a4): undefined reference to `mc13xxx_reg_rmw'
> mc13xxx-regulator-core.c:(.text+0x9b6b6): undefined reference to `mc13xxx_unlock'
> 
> Please build test this stuff ...
> 

Sorry, this driver does build as built-in.

Yong, can you send a patch *today* that fixes the modular build for
this.

Thanks

Liam 

-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

