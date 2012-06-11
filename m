Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316Ab2FKVm0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 17:42:26 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:34051 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424Ab2FKVmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 17:42:25 -0400
MIME-Version: 1.0
In-Reply-To: <1339428307-3850-14-git-send-email-lee.jones@linaro.org>
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org>
	<1339428307-3850-14-git-send-email-lee.jones@linaro.org>
Date: Mon, 11 Jun 2012 23:42:24 +0200
Message-ID: <CACRpkdb56UA0-uxKFYQ+fZmJf9Y26NwWLdKc5x-ZBfqUK0cTFg@mail.gmail.com>
Subject: Re: [PATCH 13/14] ARM: ux500: Enable the AB8500 RTC for all DT:ed
 DB8500 based devices
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de, grant.likely@secretlab.ca
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 5:25 PM, Lee Jones <lee.jones@linaro.org> wrote:

> Here we add a node for the AB8500 Real Time Clock in all devices
> supporting the DB8500. The AB8500 RTC driver makes use of named
> interrupts we provide support for this too.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
