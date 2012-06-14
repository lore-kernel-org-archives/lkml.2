Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132Ab2FNAYV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 20:24:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38467 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590Ab2FNAYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 20:24:20 -0400
Date: Wed, 13 Jun 2012 17:22:34 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>, Arnd Bergmann <arnd@arndb.de>,
        John Stultz <john.stultz@linaro.org>, Shuah Khan <shuahkhan@gmail.com>,
        arve@android.com, Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: Re: [PATCH v5 0/11] Merge ram_console into pstore
Message-ID: <20120614002234.GB29785@lizard>
References: <20120526131747.GA15054@lizard>
 <20120614000504.GA11990@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120614000504.GA11990@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 05:05:04PM -0700, Greg Kroah-Hartman wrote:
> On Sat, May 26, 2012 at 06:17:48AM -0700, Anton Vorontsov wrote:
> > The old ram_console driver is removed. This might probably cause
> > some pain for out-of-tree code, as it would need to be adjusted...
> > but "no pain, no gain"? :-) Though, if there's some serious resistance,
> > we can probably postpone the last two patches.
> 
> What out-of-tree code would care about this?

Vendors' board-support code, namely Android/ARM out-of-tree board
support files that happened to use ram_console for debugging. The
affected code in question would be just a few lines related to the
ram_console platform device registration, so no big deal.

> Anyway, all now applied, thanks for working on this.

Thank you!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
