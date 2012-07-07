Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599Ab2GGF51 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 01:57:27 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:40947 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751270Ab2GGF5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 01:57:25 -0400
X-Sasl-enc: 2nhX4dxv0L0RWevP86hASKF35/sego/yyf+Srb1RVe1o 1341640645
Date: Fri, 6 Jul 2012 22:57:23 -0700
From: Greg KH <greg@kroah.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 07/36] AArch64: Assembly macros and definitions
Message-ID: <20120707055723.GA26762@kroah.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
 <1341608777-12982-8-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341608777-12982-8-git-send-email-catalin.marinas@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, 2012 at 10:05:48PM +0100, Catalin Marinas wrote:
> +++ b/arch/aarch64/include/asm/assembler.h
> @@ -0,0 +1,143 @@
> +/*
> + * Based on arch/arm/include/asm/assembler.h
> + *
> + * Copyright (C) 1996-2000 Russell King
> + * Copyright (C) 2012 ARM Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

You do this in all of your new files, and I have to ask, are you really
willing to keep up with the office location of the FSF for the next 40+
years?  I suggest dropping this last paragraph if at all possible.

thanks,

greg k-h
