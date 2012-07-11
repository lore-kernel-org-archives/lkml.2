Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030340Ab2GKWIH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 18:08:07 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:50177 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030280Ab2GKWIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 18:08:04 -0400
MIME-Version: 1.0
In-Reply-To: <f77496c24aa05320ad8cdc81759dd16d7bbb9d65.1341925681.git.cmahapatra@ti.com>
References: <cover.1341925681.git.cmahapatra@ti.com>
	<f77496c24aa05320ad8cdc81759dd16d7bbb9d65.1341925681.git.cmahapatra@ti.com>
Date: Thu, 12 Jul 2012 00:08:03 +0200
Message-ID: <CACRpkdYZRzK4jTiQxra46KgSt8x1Vrq4GCFWyc62e303HVoZ+w@mail.gmail.com>
Subject: Re: [PATCH 3/4] OMAP: Define TCA6424 max number of possible IRQs
From: Linus Walleij <linus.walleij@linaro.org>
To: Chandrabhanu Mahapatra <cmahapatra@ti.com>,
        Tony Lindgren <tony@atomide.com>
Cc: grant.likely@secretlab.ca, linus.walleij@stericsson.com,
        rob.herring@calxeda.com, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, leed.aguilar@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2012 at 3:36 PM, Chandrabhanu Mahapatra
<cmahapatra@ti.com> wrote:
> From: Leed Aguilar <leed.aguilar@ti.com>
>
> TCA6424 being a 24 bit I2C and SMBus I/O expander has 24 available GPIO lines
> that can be used as IRQs lines. So, the support for 24 more IRQ lines has been
> added to the kernel.
>
> Change-Id: I22e4fbb3a1e4c4b53ae698a9b22cdb0f4ad7f4e6

Gerrit crap, delete it.

> Signed-off-by: Leed Aguilar <leed.aguilar@ti.com>
> Signed-off-by: Chandrabhanu Mahapatra <cmahapatra@ti.com>

I need an ACK from Tony Lindgren for this patch if I shall take it through
the GPIO tree.

Yours,
Linus Walleij
