Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759452Ab2EVPZh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 11:25:37 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49501 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757122Ab2EVPZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 11:25:34 -0400
MIME-Version: 1.0
In-Reply-To: <1337696279-8994-2-git-send-email-anton.vorontsov@linaro.org>
References: <20120522141717.GA31574@lizard>
	<1337696279-8994-2-git-send-email-anton.vorontsov@linaro.org>
Date: Tue, 22 May 2012 08:25:33 -0700
X-Google-Sender-Auth: V_jspfimw_PAv6svj57YUlctCNE
Message-ID: <CAGXu5jJ49LxeNgznWzW-Lb77jqUWkQLtUm855ExPhsZS7PowgQ@mail.gmail.com>
Subject: Re: [PATCH 02/16] pstore/ram: Should update old dmesg buffer before reading
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
> Without the update, we'll only see the new dmesg buffer after the
> reboot, but previously we could see it right away. Making an oops
> visible in pstore filesystem before reboot is a somewhat dubious
> feature, but removing it wasn't an intentional change, so let's
> restore it.
>
> For this we have to make persistent_ram_save_old() safe for calling
> multiple times, and also extern it.
>
> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>

Acked-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
Chrome OS Security
