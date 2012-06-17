Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757825Ab2FQSBX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 14:01:23 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:33743 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757708Ab2FQSBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 14:01:22 -0400
MIME-Version: 1.0
In-Reply-To: <1339927893-8842-2-git-send-email-stigge@antcom.de>
References: <1339927893-8842-1-git-send-email-stigge@antcom.de>
	<1339927893-8842-2-git-send-email-stigge@antcom.de>
Date: Sun, 17 Jun 2012 20:01:21 +0200
Message-ID: <CACRpkdaVciTXZ0XY5RvWzHPwh5iXQ7DVSD48K7prgmY0WdyF9g@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] mmc: mmci.c: Defer probe() in case of yet
 uninitialized GPIOs
From: Linus Walleij <linus.walleij@linaro.org>
To: Roland Stigge <stigge@antcom.de>
Cc: cjb@laptop.org, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        rmk+kernel@arm.linux.org.uk, ulf.hansson@stericsson.com,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        aletes.xgr@gmail.com, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 17, 2012 at 12:11 PM, Roland Stigge <stigge@antcom.de> wrote:

> If the GPIOs used by the MMCI driver are not registered yet when the driver is
> probe()d, they can't be used. This happens if the mmci driver is probed before
> the respective GPIO controller (e.g. on the LPC32xx EA3250 board, the PCA9532
> GPIO controller would be initialized via DT after mmci). Therefore, we defer
> mmci in this case.
>
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Pls put this into Russell's patch tracker.

Yours,
Linus Walleij
