Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054Ab2GKGa7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 02:30:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33205 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017Ab2GKGa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 02:30:57 -0400
Date: Tue, 10 Jul 2012 23:28:58 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Kees Cook <keescook@chromium.org>
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
Subject: Re: [PATCH resend 0/3] pstore/ram: Configurable ECC size
Message-ID: <20120711062857.GA11927@lizard>
References: <20120709234559.GA22203@lizard>
 <CAGXu5jLw_r895LPg7MweU3J7QEUYMdD6gJV8hBoF-=xdF9ow2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAGXu5jLw_r895LPg7MweU3J7QEUYMdD6gJV8hBoF-=xdF9ow2w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2012 at 01:17:48PM -0700, Kees Cook wrote:
> On Mon, Jul 9, 2012 at 4:45 PM, Anton Vorontsov
> <anton.vorontsov@linaro.org> wrote:
> > Just a few patches left from the series that used to add configurable
> > ECC size for pstore/ram backend. Most patches were merged into -next,
> > and this is just a resend of the leftovers.
> 
> Feel free to add my:
> 
> Acked-by: Kees Cook <keescook@chromium.org>
> 
> to this series. Looks good to me.

Thanks for looking at this, Kees!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
