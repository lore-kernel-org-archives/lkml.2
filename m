Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583Ab1LURfa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 12:35:30 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57896 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689Ab1LURf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 12:35:28 -0500
MIME-Version: 1.0
X-Originating-IP: [93.172.169.13]
In-Reply-To: <20111212103301.5ff6a582dca82394ace40e8d@canb.auug.org.au>
References: <CAK=WgbaU6vpiBGSgogYPjQNmrF-U0wk1rSXMX83DdgQa9hw5Mw@mail.gmail.com>
 <20111212103301.5ff6a582dca82394ace40e8d@canb.auug.org.au>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 21 Dec 2011 19:35:07 +0200
Message-ID: <CAK=WgbZm9txdvZ1VW-iUn5306yMz1Y=DT_Uygwi6zPZNyWx7gA@mail.gmail.com>
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

On Mon, Dec 12, 2011 at 1:33 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> On Fri, 9 Dec 2011 16:55:27 +0200 Ohad Ben-Cohen <ohad@wizery.com> wrote:
>>
>> Can you please add the following remoteproc tree to linux-next ?
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/ohad/remoteproc.git for-next
>
> I have added that from today.

Would you like rpmsg/remoteproc to go through arm-soc or do you prefer
me to send a pull request directly to Linus ?

If you prefer the former (IIRC you told me you might consider it in a
random ELCE hallway conversation :) then I'll send you a pull request.

I'm happy either way.

Thanks!
Ohad.
