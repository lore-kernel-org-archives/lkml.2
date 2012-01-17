Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569Ab2AQUAt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 15:00:49 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51508 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163Ab2AQUAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 15:00:47 -0500
MIME-Version: 1.0
X-Originating-IP: [93.172.29.3]
In-Reply-To: <CAK=WgbbZBUiQkCOd=XqT9X_KexKKPft3NB6MCPK1DXfPcqAZ2w@mail.gmail.com>
References: <CAK=WgbbZBUiQkCOd=XqT9X_KexKKPft3NB6MCPK1DXfPcqAZ2w@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 17 Jan 2012 22:00:26 +0200
Message-ID: <CAK=WgbZV3PY=ujdLc=8t2F+XJiNfob1z8Tsz=ea77fPwHVxRjg@mail.gmail.com>
Subject: Re: [GIT PULL] adding rpmsg and remoteproc to 3.3
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, "Grosen, Mark" <mgrosen@ti.com>,
        Brian Swetland <swetland@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Tony Lindgren <tony@atomide.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Greg KH <greg@kroah.com>,
        akpm@linux-foundation.org, Stephen Boyd <sboyd@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, "Shah, Bhavin" <bshah@ti.com>,
        Iliyan Malchev <malchev@google.com>, "Anna, Suman" <s-anna@ti.com>,
        "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 9:01 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> Please pull:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/ohad/remoteproc.git for-next-acked
>
> To get the remoteproc and rpmsg frameworks, and a few fixes that were
> collected after the frameworks were already merged into linux-next.
>
> (I also tried to push this as a signed tag "rpmsg-for-3.3" but
> am not sure how successful that feat really was)

git log --show-signature gives me the exact same output as git log
does (just built 1.7.9.rc1.3.gb6310 to have it), so I'm not sure about
the signature revalidation.

But I do see the tag and it looks sane, and being able to include a
merge commentary is indeed nice. And I guess the signature
revalidation isn't too important since I'm anyway using k.org.

Please let me know if there are any issues,

Thanks,
Ohad.
