Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804Ab2GPOxh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 10:53:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41172 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890Ab2GPOxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 10:53:35 -0400
Date: Mon, 16 Jul 2012 07:53:27 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        John Stultz <john.stultz@linaro.org>, Shuah Khan <shuahkhan@gmail.com>,
        arve@android.com, Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: Re: [PATCH v4 0/8] Function tracing support for pstore
Message-ID: <20120716145327.GA3750@kroah.com>
References: <20120710001004.GA22744@lizard>
 <20120716071421.GA21207@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120716071421.GA21207@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2012 at 12:14:21AM -0700, Anton Vorontsov wrote:
> Hi Greg,
> 
> On Fri, Jun 15, 2012 at 02:28:24PM -0700, Greg Kroah-Hartman wrote:
> [...]
> > This looks fine to me, but as it touches pstore and tracing code, I
> > can't apply it without acks from the relevant maintainers/owners.
> 
> Now that the patchset has an ack from Steven Rostedt, can you please
> apply it? I know, it might be a bit late, but we still have a week
> (or more :-), plus the patches are really not that intrusive as the
> initial pstore rework; now it's just small feature additions.

Ok, I'll queue it up later today or tomorrow.

greg k-h
