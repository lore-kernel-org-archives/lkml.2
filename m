Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973Ab2I3I0Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 04:26:16 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:55943 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491Ab2I3I0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 04:26:10 -0400
MIME-Version: 1.0
In-Reply-To: <1348559774-15484-1-git-send-email-stigge@antcom.de>
References: <1348559774-15484-1-git-send-email-stigge@antcom.de>
Date: Sun, 30 Sep 2012 10:26:08 +0200
Message-ID: <CACRpkdYU4sjzcstrTx+apgN1Cp8fF_C9WCkhpmPJzsFTDx6qqA@mail.gmail.com>
Subject: Re: [PATCH 1/2] gpio-lpc32xx: Add GPI_28
From: Linus Walleij <linus.walleij@linaro.org>
To: Roland Stigge <stigge@antcom.de>
Cc: grant.likely@secretlab.ca, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, aletes.xgr@gmail.com,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 9:56 AM, Roland Stigge <stigge@antcom.de> wrote:

> This patch adds the missing gpi28 to the list of GPIOs in the GPI P3 "chip".
>
> NOTE: This patch depends on incrementing LPC32XX_GPI_P3_MAX.  When applied
> without the respective mach-lpc32xx patch (merged via arm-soc.git), gcc will
> give a warning about "excess elements in array initializer" but this doesn't
> harm.
>
> Signed-off-by: Roland Stigge <stigge@antcom.de>

OK patch applied.

Yours,
Linus Walleij
