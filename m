Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab2FKU6V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 16:58:21 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:38459 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194Ab2FKU6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 16:58:18 -0400
MIME-Version: 1.0
In-Reply-To: <1339428307-3850-6-git-send-email-lee.jones@linaro.org>
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org>
	<1339428307-3850-6-git-send-email-lee.jones@linaro.org>
Date: Mon, 11 Jun 2012 22:58:17 +0200
Message-ID: <CACRpkdZzHctwtssvtE4HZv0H2mZwBMCYwVv+EA_n7CoV0iKNsg@mail.gmail.com>
Subject: Re: [PATCH 05/14] mfd: Enable DT probing of the DB8500 PRCMU
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de, grant.likely@secretlab.ca,
        Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 5:24 PM, Lee Jones <lee.jones@linaro.org> wrote:

> This patch adds the correct compatible string for use during Device Tree
> population. Without it the DB8500 PRCMU will not be probed.
>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks,
Linus Walleij
