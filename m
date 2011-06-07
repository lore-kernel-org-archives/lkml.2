Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549Ab1FGJ2U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 05:28:20 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:45339 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102Ab1FGJ2R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 05:28:17 -0400
MIME-Version: 1.0
In-Reply-To: <20110605071331.26277.15066.stgit@ponder>
References: <20110605071331.26277.15066.stgit@ponder>
Date: Tue, 7 Jun 2011 11:28:17 +0200
Message-ID: <BANLkTimVd7_r_qXouh+OS+p3bzzTzZ_DXw@mail.gmail.com>
Subject: Re: [PATCH] spi: reorganize drivers
From: Linus Walleij <linus.walleij@linaro.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: spi-devel-generl@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 5, 2011 at 9:13 AM, Grant Likely <grant.likely@secretlab.ca> wrote:

> Sort the SPI makefile and enforce the naming convention spi_*.c for
> spi drivers.
(...)
>  rename drivers/spi/{amba-pl022.c => spi_pl022.c} (100%)

Whatever the subsystem maintainer likes, that file was named like that
since many other AMBA-based drivers are named like that.

Acked-by: Linus Walleij <linus.walleij@linaro.org>

I might have a few patches to that file next cycle, I guess I'll
just base them on your tree FTM.

Yours,
Linus Walleij
