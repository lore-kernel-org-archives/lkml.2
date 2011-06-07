Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849Ab1FGN06 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 09:26:58 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:36921 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755Ab1FGN05 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 09:26:57 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTimVd7_r_qXouh+OS+p3bzzTzZ_DXw@mail.gmail.com>
References: <20110605071331.26277.15066.stgit@ponder> <BANLkTimVd7_r_qXouh+OS+p3bzzTzZ_DXw@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 7 Jun 2011 07:26:37 -0600
X-Google-Sender-Auth: VlQL5riTim3aOJdVnTVwIHjzZYU
Message-ID: <BANLkTik6PgS=85DkjVXSjLkxm6y7Ciwvpg@mail.gmail.com>
Subject: Re: [PATCH] spi: reorganize drivers
To: Linus Walleij <linus.walleij@linaro.org>
Cc: spi-devel-generl@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 7, 2011 at 3:28 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Sun, Jun 5, 2011 at 9:13 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
>
>> Sort the SPI makefile and enforce the naming convention spi_*.c for
>> spi drivers.
> (...)
>>  rename drivers/spi/{amba-pl022.c => spi_pl022.c} (100%)
>
> Whatever the subsystem maintainer likes, that file was named like that
> since many other AMBA-based drivers are named like that.
>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>
> I might have a few patches to that file next cycle, I guess I'll
> just base them on your tree FTM.

Sure, although file renames are not a big deal when picking up
patches.  I'm also okay with patches based on Linus' tree.

g.
