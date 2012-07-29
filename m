Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284Ab2G2Ptb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 11:49:31 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:61212 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232Ab2G2Pta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 11:49:30 -0400
MIME-Version: 1.0
In-Reply-To: <03736c1b42a7e28fc0b47aabd5c0f019edb1baf2.1343026861.git.cmahapatra@ti.com>
References: <cover.1341925681.git.cmahapatra@ti.com>
	<cover.1343026861.git.cmahapatra@ti.com>
	<03736c1b42a7e28fc0b47aabd5c0f019edb1baf2.1343026861.git.cmahapatra@ti.com>
Date: Sun, 29 Jul 2012 17:49:29 +0200
Message-ID: <CACRpkdaV+ZSwydNdCh6i_psryXGRcv=8sOaynvACbMGdp03Tjg@mail.gmail.com>
Subject: Re: [PATCH V1 3/3] OMAP: Define TCA6424 max number of possible IRQs
From: Linus Walleij <linus.walleij@linaro.org>
To: Chandrabhanu Mahapatra <cmahapatra@ti.com>,
        ext Tony Lindgren <tony@atomide.com>
Cc: linus.walleij@stericsson.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, Kevin Hilman <khilman@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 28, 2012 at 8:10 AM, Chandrabhanu Mahapatra
<cmahapatra@ti.com> wrote:

> From: Leed Aguilar <leed.aguilar@ti.com>
>
> TCA6424 being a 24 bit I2C and SMBus I/O expander has 24 available GPIO lines
> that can be used as IRQs lines. So, the support for 24 more IRQ lines has been
> added to the kernel.
>
> Signed-off-by: Leed Aguilar <leed.aguilar@ti.com>
> Signed-off-by: Chandrabhanu Mahapatra <cmahapatra@ti.com>

Tony, this seems to touch only OMAP code, can you judge on it
and take it into your tree of desired?

Alternatively I can merge it to GPIO but then I need your ACK.

Yours,
Linus Walleij
