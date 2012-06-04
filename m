Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344Ab2FDRIt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 13:08:49 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:50914 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875Ab2FDRIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 13:08:45 -0400
MIME-Version: 1.0
In-Reply-To: <1338727219-24141-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1338727219-24141-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Date: Mon, 4 Jun 2012 19:08:43 +0200
Message-ID: <CACRpkdZJPH__FzsUmKnQhTOtJ1EstJ8K5LzhTXGUO_VSzrjLew@mail.gmail.com>
Subject: Re: [PATCH] gpiolib: wm8994: Use irq_domain mappings for gpios
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 3, 2012 at 2:40 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:

> This has no practical impact at present since we don't support device tree
> so any user must have set an irq_base but this will in future allow a
> transition to device tree with minimal invasiveness.
>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

I read some drivers/base/regmap code and I think I understand this stuff
now, but seriously, it's quite hard to see the forest with all these trees,
and regmap is actually one of the finest new things in recent kernels,
so can could we create
Documentation/driver-model/regmap.txt?

I think this document is needed... I would write it myself if I felt I
understood the regmap overall concepts well enough, but I'm
certain to get something wrong.

Yours,
Linus Walleij
