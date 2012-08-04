Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210Ab2HDXiT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 19:38:19 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:56326 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050Ab2HDXiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 19:38:17 -0400
MIME-Version: 1.0
In-Reply-To: <a7d63a5023b354c3f0ac8b1aa181b57f03db199c.1343026861.git.cmahapatra@ti.com>
References: <cover.1341925681.git.cmahapatra@ti.com>
	<cover.1343026861.git.cmahapatra@ti.com>
	<a7d63a5023b354c3f0ac8b1aa181b57f03db199c.1343026861.git.cmahapatra@ti.com>
Date: Sun, 5 Aug 2012 01:38:16 +0200
Message-ID: <CACRpkdZaxoAm-gDUFMbSaumozoWH2m7vcfsc7zD4Uzt9cdabEA@mail.gmail.com>
Subject: Re: [PATCH V1 1/3] GPIO: PCA953X: Increase size of invert variable to
 support 24 bit
From: Linus Walleij <linus.walleij@linaro.org>
To: Chandrabhanu Mahapatra <cmahapatra@ti.com>
Cc: linus.walleij@stericsson.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, leed.aguilar@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 28, 2012 at 8:07 AM, Chandrabhanu Mahapatra
<cmahapatra@ti.com> wrote:

> TCA6424 is a low voltage 24 bit I2C and SMBus I/O expander of pca953x family
> similar to its 16 bit predecessor TCA6416. It comes with three 8-bit active
> Input, Output, Polarity Inversion and Configuration registers each. The polarity
> of Input ports can be reversed by setting the appropiate bit in Polarity
> Inversion registers.
>
> The variables corresponding to Input, Output and Configuration registers have
> already been updated to support 24 bit values. This patch thus updates the
> invert variable of PCA953X platform data to support 24 bit.
>
> Signed-off-by: Chandrabhanu Mahapatra <cmahapatra@ti.com>

Why did you re-send this?

The patch is already in the upstream kernel. Please rebase your tree to v3.6-rc1
or so.

Yours,
Linus Walleij
