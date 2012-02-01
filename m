Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165Ab2BAHVY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 02:21:24 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49849 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab2BAHVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 02:21:22 -0500
MIME-Version: 1.0
X-Originating-IP: [93.173.140.105]
In-Reply-To: <201112221522.21146.arnd@arndb.de>
References: <CAK=WgbaU6vpiBGSgogYPjQNmrF-U0wk1rSXMX83DdgQa9hw5Mw@mail.gmail.com>
 <20111212103301.5ff6a582dca82394ace40e8d@canb.auug.org.au>
 <CAK=WgbZm9txdvZ1VW-iUn5306yMz1Y=DT_Uygwi6zPZNyWx7gA@mail.gmail.com> <201112221522.21146.arnd@arndb.de>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 1 Feb 2012 09:21:02 +0200
Message-ID: <CAK=WgbZK_fS_rPWZ9pNARia3sp4+jL5GmR0UmyE59WZSObfWEQ@mail.gmail.com>
Subject: Re: Adding remoteproc/rpmsg to linux-next
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-next@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Brian Swetland <swetland@google.com>, akpm@linux-foundation.org,
        Greg KH <greg@kroah.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Saravana Kannan <skannan@codeaurora.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Thu, Dec 22, 2011 at 5:22 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> If you think you need more Acks or if there are other
> reasons to have it go through arm-soc, please tell me and I'll try harder
> to find the time for a proper review.

Any chance you could carve out some time for reviewing remoteproc and
rpmsg [1] ?

I hope we could either get your Acks on the patches or even have it go
through arm-soc for 3.4.

Thanks!
Ohad.

[1] git://git.kernel.org/pub/scm/linux/kernel/git/ohad/remoteproc.git
rpmsg-for-3.3
