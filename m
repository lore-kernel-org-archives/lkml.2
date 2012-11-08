Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757007Ab2KHVPN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 16:15:13 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:33003 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756670Ab2KHVPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 16:15:11 -0500
MIME-Version: 1.0
In-Reply-To: <20121107045059.GA12752@dev.danweeks.net>
References: <20121107045059.GA12752@dev.danweeks.net>
Date: Thu, 8 Nov 2012 22:15:10 +0100
Message-ID: <CACRpkdYQQXTbwhDzTDvadmVvLv+WtkhC9j1_bq1bqp2+C81f_Q@mail.gmail.com>
Subject: Re: [PATCHv2] gpio-mcp23s08: Build I2C support even when CONFIG_I2C=m
From: Linus Walleij <linus.walleij@linaro.org>
To: "Daniel M. Weeks" <dan@danweeks.net>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 7, 2012 at 5:51 AM, Daniel M. Weeks <dan@danweeks.net> wrote:

> The driver has both SPI and I2C pieces. The appropriate pieces are built based
> on whether SPI and/or I2C is/are enabled. However, it was only checking if I2C
> was built-in, never if it was built as a module. This patch checks for either
> since building both this driver and I2C as modules is possible.
>
> Signed-off-by: Daniel M. Weeks <dan@danweeks.net>

Thanks, patch merged to my fixes branch.

Yours,
Linus Walleij
