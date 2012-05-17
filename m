Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967332Ab2EQQjz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 12:39:55 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61223 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966239Ab2EQQjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 12:39:52 -0400
MIME-Version: 1.0
In-Reply-To: <20120517084132.GF31753@lizard>
References: <20120517083740.GA25627@lizard>
	<20120517084132.GF31753@lizard>
Date: Thu, 17 May 2012 09:39:51 -0700
X-Google-Sender-Auth: 6iE-r2eDNpSL79Ma4ChlT7TWpnw
Message-ID: <CAGXu5jK00Ue5W+kRwbgBtwaLst2-DYKxNFSbFomYNqHBa5GRKw@mail.gmail.com>
Subject: Re: [PATCH 6/6] pstore/ram_core: Remove now unused code
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

On Thu, May 17, 2012 at 1:41 AM, Anton Vorontsov
<anton.vorontsov@linaro.org> wrote:
> The code tried to maintain the global list of persistent ram zones,
> which isn't a great idea overall, plus since Android's ram_console
> is no longer there, we can remove some unused functions.
>
> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook
Chrome OS Security
