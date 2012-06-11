Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab2FKU5a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 16:57:30 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:39541 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab2FKU52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 16:57:28 -0400
MIME-Version: 1.0
In-Reply-To: <1339428307-3850-5-git-send-email-lee.jones@linaro.org>
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org>
	<1339428307-3850-5-git-send-email-lee.jones@linaro.org>
Date: Mon, 11 Jun 2012 22:57:27 +0200
Message-ID: <CACRpkdZpf_+VJSxSsvTQ6t-ALx8Gzv=Jf2-o3cK-CHxWJs6sPg@mail.gmail.com>
Subject: Re: [PATCH 04/14] mfd: Remove redundant Kconfig entry
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de, grant.likely@secretlab.ca
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 5:24 PM, Lee Jones <lee.jones@linaro.org> wrote:

> During ab8500-core clean-up the Kconfig entry for AB8500_I2C_CORE
> was left remnant. This patch simply removes it.
>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Sam, will you pick this patch for the -rc series?

Yours,
Linus Walleij
