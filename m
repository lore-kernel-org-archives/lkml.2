Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055Ab2GJURv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 16:17:51 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:58184 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739Ab2GJURt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 16:17:49 -0400
MIME-Version: 1.0
In-Reply-To: <20120709234559.GA22203@lizard>
References: <20120709234559.GA22203@lizard>
Date: Tue, 10 Jul 2012 13:17:48 -0700
X-Google-Sender-Auth: 3F-RdntacKr2mXWxP1fCQdK9Sf4
Message-ID: <CAGXu5jLw_r895LPg7MweU3J7QEUYMdD6gJV8hBoF-=xdF9ow2w@mail.gmail.com>
Subject: Re: [PATCH resend 0/3] pstore/ram: Configurable ECC size
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

On Mon, Jul 9, 2012 at 4:45 PM, Anton Vorontsov
<anton.vorontsov@linaro.org> wrote:
> Just a few patches left from the series that used to add configurable
> ECC size for pstore/ram backend. Most patches were merged into -next,
> and this is just a resend of the leftovers.

Feel free to add my:

Acked-by: Kees Cook <keescook@chromium.org>

to this series. Looks good to me.

-Kees

-- 
Kees Cook
Chrome OS Security
