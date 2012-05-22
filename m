Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759480Ab2EVP0t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 11:26:49 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:65375 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754720Ab2EVP0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 11:26:45 -0400
MIME-Version: 1.0
In-Reply-To: <1337696279-8994-4-git-send-email-anton.vorontsov@linaro.org>
References: <20120522141717.GA31574@lizard>
	<1337696279-8994-4-git-send-email-anton.vorontsov@linaro.org>
Date: Tue, 22 May 2012 08:26:43 -0700
X-Google-Sender-Auth: OHZkqdwTt6CRrtWaWeJrrhQEdBU
Message-ID: <CAGXu5jJz_cPps-DL7p8AzHVz8qhutqkm=67LFO52OLL9r4hq4w@mail.gmail.com>
Subject: Re: [PATCH 04/16] pstore/ram_core: Factor persistent_ram_zap() out of post_init()
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

On Tue, May 22, 2012 at 7:17 AM, Anton Vorontsov
<anton.vorontsov@linaro.org> wrote:
> A handy function that we will use outside of ram_core soon. But
> so far just factor it out and start using it in post_init().
>
> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>

Acked-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
Chrome OS Security
