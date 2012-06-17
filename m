Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757872Ab2FQSGJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 14:06:09 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:40137 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757816Ab2FQSGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 14:06:07 -0400
MIME-Version: 1.0
In-Reply-To: <1339927893-8842-3-git-send-email-stigge@antcom.de>
References: <1339927893-8842-1-git-send-email-stigge@antcom.de>
	<1339927893-8842-3-git-send-email-stigge@antcom.de>
Date: Sun, 17 Jun 2012 20:06:06 +0200
Message-ID: <CACRpkdZMpmjbg-onF9bohBjrt0AadcauzJ-w2VpgbqJ8Kz9YDg@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] mmc: mmci.c: Remove wrong error handling of gpio 0
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

> Zero is a valid GPIO and shouldn't be handled as an error return code from
> of_get_named_gpio(). It was a leftover from old code before getting
> pdata->gpio_*() was modified.
>
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Pls put this into Russell's patch tracker with the other patch.

Yours,
Linus Walleij
