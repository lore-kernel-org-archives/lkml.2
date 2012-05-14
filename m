Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932445Ab2ENVnM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 17:43:12 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47372 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932258Ab2ENVnK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 17:43:10 -0400
MIME-Version: 1.0
In-Reply-To: <20120512001831.GI14782@lizard>
References: <20120512001506.GA8653@lizard>
	<20120512001831.GI14782@lizard>
Date: Mon, 14 May 2012 14:43:09 -0700
X-Google-Sender-Auth: 43Z9igZdYCnshcmKqXulo-THoI4
Message-ID: <CAGXu5jKBxqGKHqmO+BXtj++W+NroiSaAZBKykncQ=a4h8G6N_g@mail.gmail.com>
Subject: Re: [PATCH 09/11] persistent_ram: Move to fs/pstore/ram_core.c
From: Kees Cook <keescook@chromium.org>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Colin Cross <ccross@android.com>, Arnd Bergmann <arnd@arndb.de>,
        John Stultz <john.stultz@linaro.org>, arve@android.com,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 5:18 PM, Anton Vorontsov
<anton.vorontsov@linaro.org> wrote:
> This is a first step for adding ECC support for pstore RAM backend: we
> will use the persistent_ram routines, kindly provided by Google.
>
> Basically, persistent_ram is a set of helper routines to deal with the
> [optionally] ECC-protected persistent ram regions.
>
> A bit of Makefile, Kconfig and header files adjustments were needed
> because of the move.
>
> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>

Acked-by: Kees Cook <keescook@chromium.org>

>  include/linux/pstore_ram.h               |   86 ++++-

This change includes the fix I suggested in the prior email, so yay. :)

-Kees

-- 
Kees Cook
Chrome OS Security
