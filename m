Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660Ab2EUG63 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 02:58:29 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:45057 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284Ab2EUG62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 02:58:28 -0400
MIME-Version: 1.0
In-Reply-To: <1337330355-17747-6-git-send-email-lee.jones@linaro.org>
References: <1337330355-17747-1-git-send-email-lee.jones@linaro.org>
	<1337330355-17747-6-git-send-email-lee.jones@linaro.org>
Date: Mon, 21 May 2012 08:58:25 +0200
Message-ID: <CACRpkdaw1nCFZ66BCGkVako3rzEKKcXy454Y33L3KsH5NVK7PA@mail.gmail.com>
Subject: Re: [PATCH 05/16] regulator: db8500-prcmu: Separate regulator
 registration from probe
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

> This will provide us with a convenient way to register regulators when
> booting with Device Tree both enabled & disabled and will save us a
> great deal of code duplication in time.
>
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks,
Linus Walleij
