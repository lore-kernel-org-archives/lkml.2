Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760018Ab2EPMyr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 08:54:47 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41952 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932111Ab2EPMyp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 08:54:45 -0400
MIME-Version: 1.0
In-Reply-To: <20120516124308.GB18345@lizard>
References: <20120516124109.GA14658@lizard>
	<20120516124308.GB18345@lizard>
Date: Wed, 16 May 2012 05:54:43 -0700
X-Google-Sender-Auth: hChV9BCM2OcEjn3eKzDnJo6CRUI
Message-ID: <CAGXu5jKPJ4hiBh9jAU-s2eLwbkxfeBgfAUOJy_BT0PQpDYyuEg@mail.gmail.com>
Subject: Re: [PATCH 2/6] ramoops: Move to fs/pstore/ram.c
From: Kees Cook <keescook@chromium.org>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Colin Cross <ccross@android.com>, Arnd Bergmann <arnd@arndb.de>,
        John Stultz <john.stultz@linaro.org>, Shuah Khan <shuahkhan@gmail.com>,
        arve@android.com, Rebecca Schultz Zavin <rebecca@android.com>,
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

On Wed, May 16, 2012 at 5:43 AM, Anton Vorontsov
<anton.vorontsov@linaro.org> wrote:
> Since ramoops was converted to pstore, it has nothing to do with character
> devices nowadays. Instead, today it is just a RAM backend for pstore.
>
> The patch just moves things around. There are a few changes were needed
> because of the move:
>
> 1. Kconfig and Makefiles fixups, of course.
>
> 2. In pstore/ram.c we have to play a bit with MODULE_PARAM_PREFIX, this
>   is needed to keep user experience the same as with ramoops driver
>   (i.e. so that ramoops.foo kernel command line arguments would still
>   work).
>
> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
> Acked-by: Marco Stornelli <marco.stornelli@gmail.com>

Acked-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
Chrome OS Security
