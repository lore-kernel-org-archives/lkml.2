Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114Ab2FNAUM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 20:20:12 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56390 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab2FNAUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 20:20:10 -0400
Date: Wed, 13 Jun 2012 17:20:05 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: John Stultz <john.stultz@linaro.org>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Shuah Khan <shuahkhan@gmail.com>, arve@android.com,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: Re: [PATCH v5 0/11] Merge ram_console into pstore
Message-ID: <20120614002005.GA18671@kroah.com>
References: <20120526131747.GA15054@lizard>
 <20120614000504.GA11990@kroah.com>
 <4FD92C5E.6070602@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FD92C5E.6070602@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 05:12:14PM -0700, John Stultz wrote:
> On 06/13/2012 05:05 PM, Greg Kroah-Hartman wrote:
> >On Sat, May 26, 2012 at 06:17:48AM -0700, Anton Vorontsov wrote:
> >>The old ram_console driver is removed. This might probably cause
> >>some pain for out-of-tree code, as it would need to be adjusted...
> >>but "no pain, no gain"? :-) Though, if there's some serious resistance,
> >>we can probably postpone the last two patches.
> >What out-of-tree code would care about this?
> I think he's referring to the persistent_ftrace work in the Android tree.
> 
> Anton did send out patches to try to get equivalent functionality
> working with pstore, but I don't know if Colin or anyone else from
> the Android team has had a chance to review it and make sure its
> sufficient.

I thought Colin did review these, as I see his acked-by on a number of
these patches...
