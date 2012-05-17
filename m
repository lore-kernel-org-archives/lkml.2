Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933312Ab2EQQbj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 12:31:39 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57917 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932172Ab2EQQbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 12:31:36 -0400
MIME-Version: 1.0
In-Reply-To: <20120517084031.GA31753@lizard>
References: <20120517083740.GA25627@lizard>
	<20120517084031.GA31753@lizard>
Date: Thu, 17 May 2012 09:31:31 -0700
X-Google-Sender-Auth: 7FzhLW0nq0wA3Hf_iFm5zZARH1U
Message-ID: <CAGXu5jJNhhrZ4=4tfJ3FJ-MCd5Jp+Op4P7SpZP4qpVoqXWL3eQ@mail.gmail.com>
Subject: Re: [PATCH 1/6] pstore: Add console log messages support
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
> Pstore doesn't support logging kernel messages in run-time, it only
> dumps dmesg when kernel oopses/panics. This makes pstore useless for
> debugging hangs caused by HW issues or improper use of HW (e.g.
> weird device inserted -> driver tried to write a reserved bits ->
> SoC hanged. In that case we don't get any messages in the pstore.
>
> Therefore, let's add a runtime logging support: PSTORE_TYPE_CONSOLE.
>
> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>

Acked-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
Chrome OS Security
