Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116Ab2BWOcH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 09:32:07 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:49602 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755227Ab2BWOcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 09:32:04 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Ohad Ben-Cohen" <ohad@wizery.com>
Subject: Re: [GIT PULL] adding rpmsg and remoteproc to 3.4
Date: Thu, 23 Feb 2012 14:31:44 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
        "linux-arm" <linux-arm-kernel@lists.infradead.org>,
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
References: <CAK=WgbZ2vfyiR0kXa4+-3y9etxQLBfD8b7QRR+r8VCpbOuBruA@mail.gmail.com>
In-Reply-To: <CAK=WgbZ2vfyiR0kXa4+-3y9etxQLBfD8b7QRR+r8VCpbOuBruA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201202231431.44497.arnd@arndb.de>
X-Provags-ID: V02:K0:Icxh52v5VCzlFksfiG9z0jcm0IKbKQ3XYzb+tfaGjPr
 SxNWyDGnaIf+TG3wGlSRtACf+F+i70AkVMrzOlaYQnEY++/ion
 NwQuh8VIAbRBbHjN9+f9kl8hcnf2erlOh3fX6aJE3s/b5x9G2T
 tcbzC6by6FXr+SsavmuTFeP2zKEM6Da/M7NtB88T7rMBrkW/jI
 gINhjjUC+apCHgcGo+vtD7wAdt1swsTLPyH4Eg3zBoHaHc+sL9
 YO0tn+xFBnA9C8e254SfwXiswU7aXdv3V0XDmShSyMvvumfaMx
 SwjlBJQxjdD1GNHiByFReQazmFzOskhezTZ1zs2hCHwXaVzQyS
 jNVEO5ZX5dp9FzRdQh0o=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 February 2012, Ohad Ben-Cohen wrote:
> 
> Hi Arnd,
> 
> Please pull:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/ohad/remoteproc.git rpmsg-for-3.4
> 
> To get the very basic rpmsg+remoteproc core functionality for 3.4.
> 
> This is basically the same stuff I sent for 3.3, with an additional
> fix and cleanup which were reported by Grant (and of course the two
> patches that fixed the 3.3 merge conflicts).
> 
> This entire patch set has been sitting in linux-next for quite some
> time. I'm not sure if it'd conflict with your tree when you pull it,
> but I can of course ask Stephen to remove my tree if things look ok to
> you.

Hi Ohad,

I've looked at the code again now and pulled it into the arm-soc
tree as the next/rpmsg branch, queued for submission to Linus in
the 3.4 merge window. There won't be any conflicts in linux-next
because the commits are identical,  so it doesn't matter whether
you leave your branch in linux-next or now.  If you have updates
on top of this branch, I can apply them directly here.

Let's see how things go after v3.4-rc1  before we decide whether
you want to keep sending patches to arm-soc for v3.5  as well or
whether you just use your own branch then.

	Arnd
