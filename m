Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758Ab2ETVOX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 17:14:23 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:65449 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736Ab2ETVOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 17:14:21 -0400
MIME-Version: 1.0
In-Reply-To: <1337262323-27692-12-git-send-email-lee.jones@linaro.org>
References: <1337262323-27692-1-git-send-email-lee.jones@linaro.org>
	<1337262323-27692-12-git-send-email-lee.jones@linaro.org>
Date: Sun, 20 May 2012 23:14:21 +0200
Message-ID: <CACRpkdY3N88=KeNa2O7fj2Un8dqd5KngyMzF9ZN6R035NxQ0XA@mail.gmail.com>
Subject: Re: [PATCH 11/18] regulator: Enable the ab8500 for Device Tree
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

On Thu, May 17, 2012 at 3:45 PM, Lee Jones <lee.jones@linaro.org> wrote:

> Here we setup the ab8500 regulator driver for DT. We first do
> this in the normal way, by providing a match structure during
> initialisation, but then we provide information so that
> whilst probing we can use existing data structures to do DT
> look-ups.
>
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

& thanks to Mark for merging.

Thanks!
Linus Walleij
