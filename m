Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512Ab2FSSlv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 14:41:51 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63632 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955Ab2FSSlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 14:41:50 -0400
MIME-Version: 1.0
In-Reply-To: <1340072156-6225-3-git-send-email-anton.vorontsov@linaro.org>
References: <20120619021050.GA19387@lizard>
	<1340072156-6225-3-git-send-email-anton.vorontsov@linaro.org>
Date: Tue, 19 Jun 2012 11:41:48 -0700
X-Google-Sender-Auth: aatOI4U7SCtYBV9FvENAhH0JzqA
Message-ID: <CAGXu5jLxh5ryQVeaEfdNBndmxgm5QU4-Ku_zyyXLs-ueX+gEqw@mail.gmail.com>
Subject: Re: [PATCH 3/7] pstore/ram_core: Proper checking for post_init errors
 (e.g. improper ECC size)
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
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 7:15 PM, Anton Vorontsov
<anton.vorontsov@linaro.org> wrote:
> We will implement variable-sized ECC buffers soon, so post_init routine
> might fail much more likely, so we'd better check for its errors.
>
> To make error handling simple, modify persistent_ram_free() to it be safe
> at all times.
>
> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>

Acked-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
Chrome OS Security
