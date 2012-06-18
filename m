Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964Ab2FRR2E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 13:28:04 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:58575 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373Ab2FRR2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 13:28:01 -0400
MIME-Version: 1.0
In-Reply-To: <1340037743-12924-1-git-send-email-stigge@antcom.de>
References: <1340037743-12924-1-git-send-email-stigge@antcom.de>
Date: Mon, 18 Jun 2012 14:28:00 -0300
Message-ID: <CAAAP30EQkS5XLqi1gt5mOKcMLTRtg5yAEvvSLr7oQGOBJvw+TA@mail.gmail.com>
Subject: Re: [PATCH 1/2] sound: tegra_wm8903: Adjust to of_get_named_gpio() change
From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
To: Roland Stigge <stigge@antcom.de>
Cc: swarren@wwwdotorg.org, cjb@laptop.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, rmk+kernel@arm.linux.org.uk,
        ulf.hansson@stericsson.com, linus.walleij@linaro.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        broonie@opensource.wolfsonmicro.com, lrg@ti.com, perex@perex.cz,
        tiwai@suse.de, alsa-devel@alsa-project.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 1:42 PM, Roland Stigge <stigge@antcom.de> wrote:
> of_get_named_gpio() was changed to return -EPROBE_DEFER in case of
> gpios not probed yet. This patch adjusts tegra_wm8903 to this.
>
> Signed-off-by: Roland Stigge <stigge@antcom.de>
Acked-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
