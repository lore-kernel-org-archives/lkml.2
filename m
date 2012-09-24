Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943Ab2IXTzy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 15:55:54 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:41350 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012Ab2IXTzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 15:55:52 -0400
MIME-Version: 1.0
In-Reply-To: <1348130883-11329-1-git-send-email-stigge@antcom.de>
References: <1348130883-11329-1-git-send-email-stigge@antcom.de>
Date: Mon, 24 Sep 2012 21:55:51 +0200
Message-ID: <CACRpkdZo5kR+Tyhos_StEFZbw3WHF_RFRknHjtU2Pz4XpFTZCA@mail.gmail.com>
Subject: Re: [PATCH] gpio-lpc32xx: Fix value handling of gpio_direction_output()
From: Linus Walleij <linus.walleij@linaro.org>
To: Roland Stigge <stigge@antcom.de>
Cc: grant.likely@secretlab.ca, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, aletes.xgr@gmail.com,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 10:48 AM, Roland Stigge <stigge@antcom.de> wrote:

> For GPIOs of gpio-lpc32xx, gpio_direction_output() ignores the value argument
> (initial value of output). This patch fixes this by setting the level
> accordingly.
>
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Applied with Alexandre's ACK, should go into stable right?
So tagging this with Cc: stable and sending for the -rc:s.

Thanks,
Linus Walleij
