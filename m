Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933Ab0I3WaY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 18:30:24 -0400
Received: from void.printf.net ([89.145.121.20]:49713 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911Ab0I3WaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 18:30:22 -0400
Date: Thu, 30 Sep 2010 23:30:11 +0100
From: Chris Ball <cjb@laptop.org>
To: Adrian Hunter <adrian.hunter@nokia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Matt Fleming <matt@console-pimps.org>,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "STEricsson_nomadik_linux@list.st.com" 
	<STEricsson_nomadik_linux@list.st.com>,
        Hanumath Prasad <hanumath.prasad@stericsson.com>,
        Kyungmin Park <kmpark@infradead.org>
Subject: Re: [PATCH] mmc: MMC 4.4 DDR support
Message-ID: <20100930223011.GB29047@void.printf.net>
References: <1278658780-26397-1-git-send-email-hanumath.prasad@stericsson.com> <AANLkTikBdBhJeQ-t2+0echJfAxz529QZEYPJtyHUsROd@mail.gmail.com> <m3pqxbsibq.fsf@pullcord.laptop.org> <20100823204829.GB6510@console-pimps.org> <20100823142816.59b12253.akpm@linux-foundation.org> <4C739F55.8030301@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C739F55.8030301@nokia.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Aug 24, 2010 at 01:30:45PM +0300, Adrian Hunter wrote:
> From: Adrian Hunter <adrian.hunter@nokia.com>
> Date: Tue, 24 Aug 2010 13:20:26 +0300
> Subject: [PATCH] mmc: Fix Dual Data Rate (DDR) support
>
> The DDR support patch needs the following fixes:
>
> - The block driver does not need to know about DDR, any more
> than it needs to know about bus width.
> - Not only the card must be switched to DDR mode.  The host
> controller must also be configured, which is done through
> the 'set_ios()' function.
> - Do not set the DDR mode state until after the switch command
> is successful.
> - Setting block length is not supported in DDR mode.  Make that
> a core function and change the other place it is used (mmc_test)
> also.
>
> Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>

Applied to mmc-next, thanks very much Adrian.

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
