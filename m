Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933Ab1CQTLi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 15:11:38 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60058 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab1CQTLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 15:11:35 -0400
Date: Thu, 17 Mar 2011 13:11:32 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Bibek BASU <bibek.basu@stericsson.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] AB8500 GPIO : Driver for 42 AB8500 GPIO pins
Message-ID: <20110317191132.GA12824@angua.secretlab.ca>
References: <1297827283-22860-1-git-send-email-bibek.basu@stericsson.com>
 <1297827283-22860-2-git-send-email-bibek.basu@stericsson.com>
 <AANLkTi=Yv1fHVTC-BVBJ3WRPGOmOC3fCJ13G-dCegLYo@mail.gmail.com>
 <AANLkTi=qN=i3VW=VXPQ1PAFTXFgo3O_jqykTkc7A7JLF@mail.gmail.com>
 <AANLkTi=o8CbHjJHZETokQP8bz5SyLnyLLadM4UMyZc=6@mail.gmail.com>
 <AANLkTinU7g4qLVwLwFXyt_j6tmGq-5MC9a-wy_cGvC9Y@mail.gmail.com>
 <AANLkTikwjRgCB8nnkTeZq+AbjQ+ugQz_WMshEFMSFo=_@mail.gmail.com>
 <AANLkTikw87uS4w15ZWZOp8bUU1jYwn1xK4tp5cSrpeYH@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikw87uS4w15ZWZOp8bUU1jYwn1xK4tp5cSrpeYH@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 15, 2011 at 03:51:09PM +0100, Linus Walleij wrote:
> On Tue, Mar 15, 2011 at 3:33 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> 
> > Ping me *after* Russell's tree gets merged and I'll pick it up.  I
> > don't want to mess about with apply-order breakage.
> 
> This driver does not depend on anything from Russells tree
> or any other tree for that matter... It's a clean merge.

  CC      drivers/gpio/ab8500-gpio.o
  /home/grant/hacking/linux-2.6/drivers/gpio/ab8500-gpio.c: In function 'ab8500_gpio_probe':
  /home/grant/hacking/linux-2.6/drivers/gpio/ab8500-gpio.c:432: error: 'MOP500_AB8500_VIR_GPIO_IRQ_BASE' undeclared (first use in this function)
  /home/grant/hacking/linux-2.6/drivers/gpio/ab8500-gpio.c:432: error: (Each undeclared identifier is reported only once
  /home/grant/hacking/linux-2.6/drivers/gpio/ab8500-gpio.c:432: error: for each function it appears in.)
  make[2]: *** [drivers/gpio/ab8500-gpio.o] Error 1
  make[1]: *** [drivers/gpio/ab8500-gpio.o] Error 2
  make: *** [sub-make] Error 2

and:

$ git grep MOP500_AB8500_VIR_GPIO_IRQ_BASE origin
$ 

Looks like I cannot merge this yet.

BTW, why is this driver hardcoding the gpio irq base address instead
of retrieving it from the platform data?

g.

