Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759469Ab2EVPco (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 11:32:44 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58157 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131Ab2EVPcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 11:32:43 -0400
MIME-Version: 1.0
In-Reply-To: <1337696279-8994-9-git-send-email-anton.vorontsov@linaro.org>
References: <20120522141717.GA31574@lizard>
	<1337696279-8994-9-git-send-email-anton.vorontsov@linaro.org>
Date: Tue, 22 May 2012 08:32:41 -0700
X-Google-Sender-Auth: BsUZfnSOIcIRHJhQbdYxHnmUZzc
Message-ID: <CAGXu5jL366wsf=MNPcuUuyYHcQ6Y9ULXW-Lxwy_H7KXzDxY4ng@mail.gmail.com>
Subject: Re: [PATCH 09/16] pstore/ram: Factor ramoops_get_dump_prz() out of ramoops_pstore_read()
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
> This will help make code clearer when we'll add support for other
> message types.
>
> The patch also changes return value from -EINVAL to 0 in case of
> end-of-records. The exact value doesn't matter for pstore (it should
> be just <= 0), but 0 feels more correct.
>
> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>

Acked-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
Chrome OS Security
