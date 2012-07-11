Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758351Ab2GKWEL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 18:04:11 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:42250 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664Ab2GKWEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 18:04:08 -0400
MIME-Version: 1.0
In-Reply-To: <d2503bb0719da649800c67f70953685da582543f.1341925681.git.cmahapatra@ti.com>
References: <cover.1341925681.git.cmahapatra@ti.com>
	<d2503bb0719da649800c67f70953685da582543f.1341925681.git.cmahapatra@ti.com>
Date: Thu, 12 Jul 2012 00:04:07 +0200
Message-ID: <CACRpkdbv9miT=jHnv1uDf5fquqRFzYEXxnm4n7zsapc0oS1w_A@mail.gmail.com>
Subject: Re: [PATCH 2/4] gpio/pca953x: increase variables size to support 24
 bit of data
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

> From: Leed Aguilar <leed.aguilar@ti.com>
>
> Increase variable size from u16 to u32 to allocate 24 bit of data required for
> the TCA6424 I/O expander device type.
>
> Signed-off-by: Leed Aguilar <leed.aguilar@ti.com>
> Signed-off-by: Chandrabhanu Mahapatra <cmahapatra@ti.com>

Looks good.

Applied.

Yours,
Linus Walleij
