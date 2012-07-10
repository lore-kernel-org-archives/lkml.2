Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979Ab2GJADN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 20:03:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45375 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646Ab2GJADM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 20:03:12 -0400
Date: Mon, 9 Jul 2012 17:01:08 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, John Stultz <john.stultz@linaro.org>,
        Shuah Khan <shuahkhan@gmail.com>, arve@android.com,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH resend 0/3] pstore/ram: Configurable ECC size
Message-ID: <20120710000107.GA31743@lizard>
References: <20120709234559.GA22203@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120709234559.GA22203@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2012 at 04:45:59PM -0700, Anton Vorontsov wrote:
> Hi all,
> 
> Just a few patches left from the series that used to add configurable
> ECC size for pstore/ram backend. Most patches were merged into -next,
> and this is just a resend of the leftovers.

Oh, I fogot: actually, it's not a plain resend, I fixed Dan Carpenter's
comment (thanks!): added more text about special ecc=1 case, both
as a module param description and as a comment in the code.

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
