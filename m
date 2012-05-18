Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968095Ab2ERVsw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 17:48:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49595 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968062Ab2ERVst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 17:48:49 -0400
Date: Fri, 18 May 2012 14:47:20 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Colin Cross <ccross@android.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Tony Luck <tony.luck@intel.com>,
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
Subject: Re: [PATCH v2 0/6] Merge ram_console into pstore
Message-ID: <20120518214720.GA29976@lizard>
References: <20120517083740.GA25627@lizard>
 <CAMbhsRTGOnjB2M7L4n38=on1dB5unF=WNCScsX9n3fWZjdGEfA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAMbhsRTGOnjB2M7L4n38=on1dB5unF=WNCScsX9n3fWZjdGEfA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 11:42:29AM -0700, Colin Cross wrote:
[...]
> Other than my comment on logging console into a single record,
> Acked-by: Colin Cross <ccross@android.com>

Thanks!

> There is one feature that ram_console had but lost when I added
> persistent_ram, which would be nice to get back:  registering the
> platform driver before module_init, to allow it to log oopses that
> happen during device probing.  This requires changing module_init to
> postcore_initcall, and switching from platform_driver_probe to
> platform_driver_register because the platform device is not registered
> when the platform driver is registered.  Depending on what functions
> are __init, it may cause a cascading change from __init to __devinit
> as well.

Yep, I'll look into it.

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
