Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760649Ab2EPWVq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 18:21:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39104 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757427Ab2EPWVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 18:21:45 -0400
Date: Wed, 16 May 2012 15:20:15 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Shuah Khan <shuahkhan@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>, Arnd Bergmann <arnd@arndb.de>,
        John Stultz <john.stultz@linaro.org>, arve@android.com,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: Re: [PATCH 2/6] pstore/ram: Add console messages handling
Message-ID: <20120516222013.GA21366@lizard>
References: <20120516125330.GA15460@lizard>
 <20120516125634.GB20475@lizard>
 <1337182252.2424.18.camel@lorien2>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1337182252.2424.18.camel@lorien2>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 09:30:52AM -0600, Shuah Khan wrote:
> On Wed, 2012-05-16 at 05:56 -0700, Anton Vorontsov wrote:
> > This is all straightforward: we just use the last region for
> > console logging. If there's just one region, we fall-back to
> > the old behaviour: just a oops/dumps logging.
> 
> What about the saving /proc/last_kmsg? Are you not bringing that feature
> from ramconsole? Sorry if I missed it in reading the patches.

Nope, sorry. The /proc/last_kms ABI is just a duplication of
pstore's console logging interface, and since last_kmsg thing is
in drivers/staging/, there's no point in keeping it, unless there's
a really good reason.

Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
