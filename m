Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab2FSSoF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 14:44:05 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38991 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787Ab2FSSoC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 14:44:02 -0400
MIME-Version: 1.0
In-Reply-To: <1340072156-6225-4-git-send-email-anton.vorontsov@linaro.org>
References: <20120619021050.GA19387@lizard>
	<1340072156-6225-4-git-send-email-anton.vorontsov@linaro.org>
Date: Tue, 19 Jun 2012 11:44:01 -0700
X-Google-Sender-Auth: kUbwCAH0kPqKXjZquNcWf9a9jf4
Message-ID: <CAGXu5jKEXSga7J1EVmishYnbbhfRHz2YEY9UJ7ZKnJ6f_0hbdA@mail.gmail.com>
Subject: Re: [PATCH 4/7] pstore/ram_core: Better ECC size checking
From: Kees Cook <keescook@chromium.org>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>,
        Arnd Bergmann <arnd@arndb.de>, John Stultz <john.stultz@linaro.org>,
        Shuah Khan <shuahkhan@gmail.com>, arve@android.com,
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

On Mon, Jun 18, 2012 at 7:15 PM, Anton Vorontsov
<anton.vorontsov@linaro.org> wrote:
> - Instead of exploiting unsigned overflows (which doesn't work for all
>  sizes), use straightforward checking for ECC total size not exceeding
>  initial buffer size;
>
> - Printing overflowed buffer_size is not informative. Instead, print
>  ecc_size and buffer_size;
>
> - No need for buffer_size argument in persistent_ram_init_ecc(),
>  we can address prz->buffer_size directly.
>
> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>

Acked-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
Chrome OS Security
