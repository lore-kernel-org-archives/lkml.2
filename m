Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957Ab1HBKOY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 06:14:24 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:36742 "EHLO linux-mips.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751783Ab1HBKOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 06:14:18 -0400
Date: Tue, 2 Aug 2011 10:24:38 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>, linux-mips@linux-mips.org
Subject: Re: [PATCH 2/7] MIPS: static should be at beginning of declaration
Message-ID: <20110802092438.GA18229@linux-mips.org>
References: <alpine.LNX.2.00.1107092304160.25516@swampdragon.chaosbits.net>
 <alpine.LNX.2.00.1107092311190.25516@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LNX.2.00.1107092311190.25516@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 09, 2011 at 11:12:35PM +0200, Jesper Juhl wrote:

> Make sure that the 'static' keywork is at the beginning of declaration
> for arch/mips/include/asm/mach-jz4740/gpio.h
> 
> This gets rid of warnings like
>   warning: ‘static’ is not at beginning of declaration
> when building with -Wold-style-declaration (and/or -Wextra which also
> enables it).
> Also a few tiny whitespace changes.

> - const static struct jz_gpio_bulk_request i2c_pins[] = {
> + static const struct jz_gpio_bulk_request i2c_pins[] = {

Quite surprising - but that still was valid C - just type for example:

int typedef (*func(const char op))(int a, int b[static const a = 3]);

  Ralf
