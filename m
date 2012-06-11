Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173Ab2FKVDv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 17:03:51 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:48694 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009Ab2FKVDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 17:03:50 -0400
MIME-Version: 1.0
In-Reply-To: <1339428307-3850-8-git-send-email-lee.jones@linaro.org>
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org>
	<1339428307-3850-8-git-send-email-lee.jones@linaro.org>
Date: Mon, 11 Jun 2012 23:03:48 +0200
Message-ID: <CACRpkdY8aD1djSdPoeKYDdFVbf3E84ZWw2Q5CCLsPmoD66Hf7A@mail.gmail.com>
Subject: Re: [PATCH 07/14] mfd: Initialise the AB8500 driver at core_initcall time
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>, grant.likely@secretlab.ca
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mattias WALLIN <mattias.wallin@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 5:25 PM, Lee Jones <lee.jones@linaro.org> wrote:

> The AB8500 is soon to have its own IRQ domain. For this to be useful
> the driver needs to be initialised earlier in the boot sequence. Here
> we move initialisation forward from arch_initcall to core_initcall time.

I don't understand why using IRQ domain makes it necessary to
initialize the driver earlier in the init process. Please explain to me,
I need tutoring here.

Thanks,
Linus Walleij
