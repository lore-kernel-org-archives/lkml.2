Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244Ab2E3R5L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 13:57:11 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52873 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756281Ab2E3R5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 13:57:09 -0400
MIME-Version: 1.0
In-Reply-To: <1338038429-21945-2-git-send-email-anton.vorontsov@linaro.org>
References: <20120526131747.GA15054@lizard>
	<1338038429-21945-2-git-send-email-anton.vorontsov@linaro.org>
Date: Wed, 30 May 2012 10:57:07 -0700
X-Google-Sender-Auth: wLj_TiJkxKPEZWpc5qMwwdgzxGY
Message-ID: <CAGXu5jKFn37Dd1n6Rf3sc7LM_0dLeSjW_W5xbULYwX6MmnRF2w@mail.gmail.com>
Subject: Re: [PATCH 02/11] pstore/ram: Give proper names to dump-related variables
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

On Sat, May 26, 2012 at 6:20 AM, Anton Vorontsov
<anton.vorontsov@linaro.org> wrote:
> We're about to add support for other message types, so let's rename
> some variables to not be confused later.

Acked-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
Chrome OS Security
