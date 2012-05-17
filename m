Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933460Ab2EQQim (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 12:38:42 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39845 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932335Ab2EQQij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 12:38:39 -0400
MIME-Version: 1.0
In-Reply-To: <20120517084052.GC31753@lizard>
References: <20120517083740.GA25627@lizard>
	<20120517084052.GC31753@lizard>
Date: Thu, 17 May 2012 09:38:37 -0700
X-Google-Sender-Auth: nXIDmRyFt289WOF5t8CBlct5hxM
Message-ID: <CAGXu5jJTNmh=JYqxsXis4JuRVViZsK55h4deDccx0JFfsDDrmg@mail.gmail.com>
Subject: Re: [PATCH 3/6] pstore/ram_core: Silence some printks
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

On Thu, May 17, 2012 at 1:40 AM, Anton Vorontsov
<anton.vorontsov@linaro.org> wrote:
> Since we use multiple regions, the messages are somewhat annoying.
> We do print total mapped memory already, so no need to print the
> information for each region in the library routines.
>
> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook
Chrome OS Security
