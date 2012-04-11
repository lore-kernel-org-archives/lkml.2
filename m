Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761160Ab2DKWrW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 18:47:22 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:35692 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756913Ab2DKWrV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 18:47:21 -0400
MIME-Version: 1.0
In-Reply-To: <9c8b8d1212528994ea09c9cc57428ce3d1f45da9.1333663714.git.rubini@gnudd.com>
References: <cover.1333663714.git.rubini@gnudd.com>
	<9c8b8d1212528994ea09c9cc57428ce3d1f45da9.1333663714.git.rubini@gnudd.com>
Date: Thu, 12 Apr 2012 00:47:20 +0200
Message-ID: <CACRpkdbDZCwQLdrPtm-VD6-iCD0hgsNos=KB7P6PL6-p=upjZA@mail.gmail.com>
Subject: Re: [PATCH 1/1] ARM: Rename CONFIG_ARM_AMBA to CONFIG_ARM_PRIMECELL
From: Linus Walleij <linus.walleij@linaro.org>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 6, 2012 at 12:22 AM, Alessandro Rubini <rubini@gnudd.com> wrote:

> The AMBA bus (Advanced Microcontroller Bus Architecture) is just an
> interconnection bus that needs no software support.  Software support
> offered in Linux is some sort of enumeration that only applies to
> "PrimeCell" logic blocks (devices).  This renames the config option
> to match reality.
>
> Change suggested by Russell King.
>
> Note: CONFIG_ARM_AMBA is retained and is enabled when
> CONFIG_ARM_PRIMECELL is selected.  So any #ifdef in out-of-tree
> drivers will still work until the symbol will be removed in due time.
>
> Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
> Cc: Russell King <linux@arm.linux.org.uk>

Yeah this thing can be a bit confusing...

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks,
Linus Walleij
