Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102Ab2FSVue (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 17:50:34 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:43306 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab2FSVuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 17:50:32 -0400
MIME-Version: 1.0
In-Reply-To: <1340011706-32281-1-git-send-email-stigge@antcom.de>
References: <1340011706-32281-1-git-send-email-stigge@antcom.de>
Date: Tue, 19 Jun 2012 23:50:32 +0200
Message-ID: <CACRpkdZH7bMVRLYdrSJjcuNOPvY5P8yGMnoVhih4ycD7AV8kUw@mail.gmail.com>
Subject: Re: [PATCH] mips: pci-lantiq: Fix check for valid gpio
From: Linus Walleij <linus.walleij@linaro.org>
To: Roland Stigge <stigge@antcom.de>
Cc: ralf@linux-mips.org, blogic@openwrt.org, jkosina@suse.cz,
        standby24x7@gmail.com, bhelgaas@google.com, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        linus.walleij@stericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 11:28 AM, Roland Stigge <stigge@antcom.de> wrote:

> This patch fixes two checks for valid gpio number, formerly (wrongly)
> considering zero as invalid, now using gpio_is_valid().
>
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks,
Linus Walleij
