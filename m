Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136Ab2BWOzE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 09:55:04 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49395 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115Ab2BWOzB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 09:55:01 -0500
MIME-Version: 1.0
X-Originating-IP: [93.172.89.250]
In-Reply-To: <201202231431.44497.arnd@arndb.de>
References: <CAK=WgbZ2vfyiR0kXa4+-3y9etxQLBfD8b7QRR+r8VCpbOuBruA@mail.gmail.com>
 <201202231431.44497.arnd@arndb.de>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Thu, 23 Feb 2012 16:54:41 +0200
Message-ID: <CAK=Wgbaa+kbYafudmwN9WHY2ezmt3UJdA2X9m4pQbfgb7EZV-w@mail.gmail.com>
Subject: Re: [GIT PULL] adding rpmsg and remoteproc to 3.4
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, "Grosen, Mark" <mgrosen@ti.com>,
        Brian Swetland <swetland@google.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Tony Lindgren <tony@atomide.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Greg KH <greg@kroah.com>,
        akpm@linux-foundation.org, Stephen Boyd <sboyd@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, "Shah, Bhavin" <bshah@ti.com>,
        Iliyan Malchev <malchev@google.com>, "Anna, Suman" <s-anna@ti.com>,
        "Guzman Lugo, Fernando" <fernando.lugo@ti.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Loic PALLARDY <loic.pallardy@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        Michal Simek <monstr@monstr.eu>, "Clark, Rob" <rob@ti.com>,
        John Williams <john.williams@petalogix.com>,
        Saravana Kannan <skannan@codeaurora.org>, arm@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 4:31 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> I've looked at the code again now and pulled it into the arm-soc
> tree as the next/rpmsg branch, queued for submission to Linus in
> the 3.4 merge window. There won't be any conflicts in linux-next
> because the commits are identical,  so it doesn't matter whether
> you leave your branch in linux-next or now.  If you have updates
> on top of this branch, I can apply them directly here.
>
> Let's see how things go after v3.4-rc1  before we decide whether
> you want to keep sending patches to arm-soc for v3.5  as well or
> whether you just use your own branch then.

Thanks!
Ohad.
