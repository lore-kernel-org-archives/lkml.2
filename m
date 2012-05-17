Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759277Ab2EQQiI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 12:38:08 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59503 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932489Ab2EQQiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 12:38:05 -0400
MIME-Version: 1.0
In-Reply-To: <20120517084042.GB31753@lizard>
References: <20120517083740.GA25627@lizard>
	<20120517084042.GB31753@lizard>
Date: Thu, 17 May 2012 09:38:00 -0700
X-Google-Sender-Auth: Z6FlWzBxCnC8vtg9sKJakCihYtI
Message-ID: <CAGXu5j+XtqhVEeoaeEdvy+vWLBDpJimi2Ttbi17q9TPsw5S9Mw@mail.gmail.com>
Subject: Re: [PATCH 2/6] pstore/ram: Add console messages handling
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
> This is all straightforward: we just use the last region for
> console logging. If there's just one region, we fall-back to
> the old behaviour: just a oops/dumps logging.
>
> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook
Chrome OS Security
