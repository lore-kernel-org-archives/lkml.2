Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968115Ab2ERVvW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 17:51:22 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60075 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759637Ab2ERVvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 17:51:18 -0400
Date: Fri, 18 May 2012 14:49:48 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Colin Cross <ccross@android.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Tony Luck <tony.luck@intel.com>,
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
Subject: Re: [PATCH 2/6] pstore/ram: Add console messages handling
Message-ID: <20120518214947.GA30293@lizard>
References: <20120517083740.GA25627@lizard>
 <20120517084042.GB31753@lizard>
 <CAMbhsRQVchQdnRTteriPqq7DZ68oROrWQr8eLjRtXGZ5q4_MrA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAMbhsRQVchQdnRTteriPqq7DZ68oROrWQr8eLjRtXGZ5q4_MrA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 11:28:22AM -0700, Colin Cross wrote:
> On Thu, May 17, 2012 at 1:40 AM, Anton Vorontsov
> <anton.vorontsov@linaro.org> wrote:
> > This is all straightforward: we just use the last region for
> > console logging. If there's just one region, we fall-back to
> > the old behaviour: just a oops/dumps logging.
> >
> > Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
> 
> I don't think using the last region is the right way to handle this.
> We often use very large regions for ramconsole, up to 2MB.  Using a
> single region would require a 2MB region for console and a 2MB region
> for oops, which is far too large.

Yeah, I agree. I planned to take care of it later, as this would
involve touching more code. But OK, let's do this right away.

Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
