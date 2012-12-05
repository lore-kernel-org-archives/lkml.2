Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501Ab2LEX2K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 18:28:10 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:41205 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab2LEX2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 18:28:08 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [v2 PATCH 02/14] of_spi: add generic binding support to specify cs gpio
To: Wenyou Yang <wenyou.yang@atmel.com>, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, nicolas.ferre@atmel.com,
        plagnioj@jcrosoft.com, richard.genoud@gmail.com, JM.Lin@atmel.com,
        wenyou.yang@atmel.com, devicetree-discuss@lists.ozlabs.org,
        spi-devel-general@lists.sourceforge.net, rob.herring@calxeda.com,
        rob@landley.net
In-Reply-To: <1354607640-13229-3-git-send-email-wenyou.yang@atmel.com>
References: <1354607640-13229-1-git-send-email-wenyou.yang@atmel.com> <1354607640-13229-3-git-send-email-wenyou.yang@atmel.com>
Date: Wed, 05 Dec 2012 23:28:02 +0000
Message-Id: <20121205232802.ECD2D3E0E22@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  4 Dec 2012 15:53:48 +0800, Wenyou Yang <wenyou.yang@atmel.com> wrote:
> From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> 
> This will allow to use gpio for chip select with no modification in the
> driver binding
> 
> When use the cs-gpios, the gpio number will be passed via the cs_gpio field
> and the number of chip select will automatically increased.
> 
> Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> Cc: devicetree-discuss@lists.ozlabs.org
> Cc: spi-devel-general@lists.sourceforge.net
> Cc: grant.likely@secretlab.ca
> Cc: rob.herring@calxeda.com
> Cc: rob@landley.net
> Cc: richard.genoud@gmail.com
> ---
> Hi, Richard,
> 
> This patch based on the original patch from Jean-Christophe, 
>  	[PATCH] of_spi: add generic binding support to specify cs gpio
> and merge the patch from Richard Genoud,
> 	[PATCH] [BUG] SPI: array out of bound => no CS
> 
> Could you sign your signature in this patch?
> 
> Best Regards,
> Wenyou Yang

I've already merged a version of this patch. Please check against the
version that is in linux-next.

g.

