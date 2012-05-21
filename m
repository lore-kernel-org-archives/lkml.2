Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab2EUG7F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 02:59:05 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:38681 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741Ab2EUG7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 02:59:03 -0400
MIME-Version: 1.0
In-Reply-To: <1337330355-17747-8-git-send-email-lee.jones@linaro.org>
References: <1337330355-17747-1-git-send-email-lee.jones@linaro.org>
	<1337330355-17747-8-git-send-email-lee.jones@linaro.org>
Date: Mon, 21 May 2012 08:59:02 +0200
Message-ID: <CACRpkdY_FngA0i+Shdga47j87X94+S7=+OQq4HW1c7jBxWoaYA@mail.gmail.com>
Subject: Re: [PATCH 07/16] regulator: Enable Device Tree for the db8500-prcmu
 regulator driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
        linus.walleij@stericsson.com, grant.likely@secretlab.ca,
        cjb@laptop.org, broonie@opensource.wolfsonmicro.com,
        sameo@linux.intel.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 10:39 AM, Lee Jones <lee.jones@linaro.org> wrote:

> Here we use the previous regulator register code separated from probe to
> register each of the regulators mentioned in Device Tree.
>
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks,
Linus Walleij
