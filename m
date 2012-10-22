Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950Ab2JVIax (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 04:30:53 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37245 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab2JVIav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 04:30:51 -0400
Date: Mon, 22 Oct 2012 09:30:45 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Ulf Hansson <ulf.hansson@stericsson.com>
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH 1/2] ASoC: Ux500: Fixup complile errors due to merge
Message-ID: <20121022083045.GA3785@gmail.com>
References: <1350653427-28611-1-git-send-email-ulf.hansson@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1350653427-28611-1-git-send-email-ulf.hansson@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2012, Ulf Hansson wrote:

> From: Ulf Hansson <ulf.hansson@linaro.org>
> 
> Likely during merge of the below commits ended up breaking compilation:
> ASoC: Ux500: Enable ux500 MSP driver for Device Tree
> ASoC: ux500_msp_i2s: better use devm functions and fix error return code

This is already fixed:
  https://patchwork.kernel.org/patch/1593881/

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
