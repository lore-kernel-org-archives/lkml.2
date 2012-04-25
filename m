Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756948Ab2DYRGJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 13:06:09 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34891 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445Ab2DYRGH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 13:06:07 -0400
MIME-Version: 1.0
In-Reply-To: <0MOCMW-1SHWKu3g28-005WSP@mrelayeu.kundenserver.de>
References: <0MOCMW-1SHWKu3g28-005WSP@mrelayeu.kundenserver.de>
Date: Wed, 25 Apr 2012 19:06:06 +0200
Message-ID: <CACRpkdb=aXHrXWEEZHpJup-rzd385Rew6QfF=ZhPRM8pBs+8hQ@mail.gmail.com>
Subject: Re: [PATCH v2] Add support for TCA6424A
From: Linus Walleij <linus.walleij@linaro.org>
To: Andreas Schallenberg <Andreas.Schallenberg@3alitytechnica.com>
Cc: grant.likely@secretlab.ca, linus.walleij@stericsson.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 3:18 PM, Andreas Schallenberg
<Andreas.Schallenberg@3alitytechnica.com> wrote:

> From 3fcb45bad283740a48c17ff078c28dd1354204ae Mon Sep 17 00:00:00 2001
> From: Andreas Schallenberg <Andreas.Schallenberg@3alitytechnica.com>
> Date: Wed, 25 Apr 2012 14:51:30 +0200
> Subject: [PATCH] Add support for TCA6424A
>
> This patch extends the PCA953x driver to support TI's TCA6424A 24 bit I2C I/O expander.
> The patch is on code by Michele Bevilacqua.
>
> Changes in v2:
> - Compare ngpio against 24 in both places, not >16
> - Larger datatype now u32 instead of uint.
>  Bit fields not used for struct members since their address is taken.
> - Be precise: TCA6424A (untested for older TCA6424)
>
> Should the chip name string read tca6424a as well?
>
> Signed-off-by: Andreas Schallenberg<Andreas.Schallenberg@3alitytechnica.com>

Looks good to me. Would be good to have this tested on the other
family members though.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
