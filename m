Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166Ab2IOLeb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 07:34:31 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:33919 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333Ab2IOLea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 07:34:30 -0400
Date: Sat, 15 Sep 2012 13:33:56 +0200
From: Alessandro Rubini <rubini@unipv.it>
To: arnd@arndb.de
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        will.deacon@arm.com, rmk+kernel@arm.linux.org.uk, nico@linaro.org,
        linus.walleij@linaro.org, STEricsson_nomadik_linux@list.st.com
Subject: Re: [PATCH 13/24] ARM: nomadik: use __iomem pointers for MMIO
Message-ID: <20120915113356.GA31284@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <1347658492-11608-14-git-send-email-arnd@arndb.de>
References: <1347658492-11608-14-git-send-email-arnd@arndb.de>
  <1347658492-11608-1-git-send-email-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -	.options	= NAND_COPYBACK | NAND_CACHEPRG | NAND_NO_PADDING \
> -			| NAND_NO_READRDY,
> +	.options	= NAND_COPYBACK | NAND_CACHEPRG | NAND_NO_PADDING,

This is not clear to me, and it looks unrelated. But I admit I haven't
studied what happened to NAND_NO_READRDY lately.

If this hunk is desired and not just something else
that slipped in, then

  Acked-by: Alessandro Rubini <rubini@unipv.it>

