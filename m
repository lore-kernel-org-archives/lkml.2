Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759572Ab2EPRx3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 13:53:29 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53839 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758978Ab2EPRx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 13:53:27 -0400
Date: Wed, 16 May 2012 10:53:22 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shuah Khan <shuahkhan@gmail.com>
Cc: devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>,
        patches@linaro.org, Marco Stornelli <marco.stornelli@gmail.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        Anton Vorontsov <anton.vorontsov@linaro.org>, arve@android.com,
        Jesper Juhl <jj@chaosbits.net>, John Stultz <john.stultz@linaro.org>,
        Colin Cross <ccross@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        WANG Cong <xiyou.wangcong@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, kernel-team@android.com,
        Thomas Meyer <thomas@m3y3r.de>
Subject: Re: [PATCH 4/6] staging: android: persistent_ram: Move to
 fs/pstore/ram_core.c
Message-ID: <20120516175322.GA3094@kroah.com>
References: <20120516124109.GA14658@lizard>
 <20120516124338.GD18345@lizard>
 <20120516150550.GA22945@kroah.com>
 <1337185786.2424.31.camel@lorien2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337185786.2424.31.camel@lorien2>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 10:29:46AM -0600, Shuah Khan wrote:
> On Wed, 2012-05-16 at 08:05 -0700, Greg Kroah-Hartman wrote:
> 
> > 
> > After applying this patch, and building things, I get the following
> > errors:
> 
> Greg,
> 
> > What went wrong?
> > 
> > I've now applied the first 3 patches in this series to my tree, plus the
> > 2 others from the linux-next tree, so care to just fix up these last
> > three and resend them?
> 
> Picking [PATCH 5/6] staging/android: Remove ram_console driver should
> fix this problem. This patches removes ram_console.c from the staging
> area.

That's nice, but you CAN NOT BREAK THE BUILD at any step of a patch
series progress.

So please rework this to prevent this from happening, as it is, I can
not accept these.

greg k-h
