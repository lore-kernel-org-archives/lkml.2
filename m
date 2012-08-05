Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab2HETK3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 15:10:29 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:39877 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481Ab2HETK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 15:10:28 -0400
MIME-Version: 1.0
In-Reply-To: <1344160356-387-5-git-send-email-Julia.Lawall@lip6.fr>
References: <1344160356-387-1-git-send-email-Julia.Lawall@lip6.fr>
	<1344160356-387-5-git-send-email-Julia.Lawall@lip6.fr>
Date: Sun, 5 Aug 2012 21:10:27 +0200
Message-ID: <CACRpkdb1dpaMiGwqLVVEgnt5ifwqufR7XfnN9qmqqBVyK1UO7Q@mail.gmail.com>
Subject: Re: [PATCH 4/6] drivers/gpio/gpio-langwell.c: fix error return code
From: Linus Walleij <linus.walleij@linaro.org>
To: Julia Lawall <Julia.Lawall@lip6.fr>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, kernel-janitors@vger.kernel.org,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, Julia Lawall <julia@diku.dk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 5, 2012 at 11:52 AM, Julia Lawall <Julia.Lawall@lip6.fr> wrote:

> From: Julia Lawall <julia@diku.dk>
>
> Convert a 0 error return code to a negative one, as returned elsewhere in the
> function.

Patch applied.

Mika/Adrian: shout if this is incorrect.

Yours,
Linus Walleij
