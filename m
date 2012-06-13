Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080Ab2FMXxg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 19:53:36 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45090 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754592Ab2FMXxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 19:53:35 -0400
Date: Wed, 13 Jun 2012 16:53:24 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>, devel@driverdev.osuosl.org,
        linaro-kernel@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        patches@linaro.org, Marco Stornelli <marco.stornelli@gmail.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        arve@android.com, Jesper Juhl <jj@chaosbits.net>,
        John Stultz <john.stultz@linaro.org>, Shuah Khan <shuahkhan@gmail.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        WANG Cong <xiyou.wangcong@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, kernel-team@android.com,
        Thomas Meyer <thomas@m3y3r.de>
Subject: Re: [PATCH 0/5] Some pstore/ramoops fixes
Message-ID: <20120613235324.GA1543@kroah.com>
References: <20120526130650.GA6242@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120526130650.GA6242@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 26, 2012 at 06:06:50AM -0700, Anton Vorontsov wrote:
> Hi Greg,
> 
> In the light of Linus' response, and I said this to Colin already, I'll
> just zap a prz at boot time for pstore/console interface, which means
> that nowadays there shouldn't be any objections to this bunch of fixes.
> 
> These are valid fixes for v3.5, they restore old pstore's behavior
> nuances, which I changed accidentaly.
> 
> Except for the last patch, which is just a fix I happened to make when
> I got bored of the warning. :-) Not a regression fix, though.

All now applied, thanks.

greg k-h
