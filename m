Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030315Ab2GKWCw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 18:02:52 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:44926 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030272Ab2GKWCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 18:02:51 -0400
MIME-Version: 1.0
In-Reply-To: <505ac716b6c758d36471a90c2a5228cedb7217be.1341925681.git.cmahapatra@ti.com>
References: <cover.1341925681.git.cmahapatra@ti.com>
	<505ac716b6c758d36471a90c2a5228cedb7217be.1341925681.git.cmahapatra@ti.com>
Date: Thu, 12 Jul 2012 00:02:50 +0200
Message-ID: <CACRpkdYX58zq2byvdWtLs-1ufN2gF=+1qokumjhoia+RThW=NA@mail.gmail.com>
Subject: Re: [PATCH 1/4] GPIO: PCA953X: Increase size of invert variable to
 support 24 bit
From: Linus Walleij <linus.walleij@linaro.org>
To: Chandrabhanu Mahapatra <cmahapatra@ti.com>
Cc: grant.likely@secretlab.ca, linus.walleij@stericsson.com,
        rob.herring@calxeda.com, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, leed.aguilar@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2012 at 3:35 PM, Chandrabhanu Mahapatra
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

I remember this (I think). So expand to 32bit to support 24 bit,
that looks reasonable.

Patch applied.

Thanks,
Linus Walleij
