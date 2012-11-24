Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800Ab2KXX2O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 18:28:14 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:36158 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752635Ab2KXX2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 18:28:13 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Olof Johansson <olof@lixom.net>
Cc: Arnd Bergmann <arnd@arndb.de>, Rob Herring <robherring2@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Rob Herring <rob.herring@calxeda.com>, Len Brown <len.brown@intel.com>
Subject: Re: [PATCH] cpuidle: add Calxeda SOC idle support
Date: Sun, 25 Nov 2012 00:32:46 +0100
Message-ID: <2198449.YMGY5GKIXr@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc6; KDE/4.9.3; x86_64; ; )
In-Reply-To: <CAOesGMgUsmjZCpMN8WpYk2LpYpfxp-wyCwajw4TikgU8ve2g0A@mail.gmail.com>
References: <1352330622-13616-1-git-send-email-robherring2@gmail.com> <2676657.zDjyfqIDdm@vostro.rjw.lan> <CAOesGMgUsmjZCpMN8WpYk2LpYpfxp-wyCwajw4TikgU8ve2g0A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, November 24, 2012 03:21:49 PM Olof Johansson wrote:
> Rafael,
> 
> On Sat, Nov 24, 2012 at 2:03 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Monday, November 12, 2012 10:00:07 PM Arnd Bergmann wrote:
> >> On Wednesday 07 November 2012, Rob Herring wrote:
> >> > From: Rob Herring <rob.herring@calxeda.com>
> >> >
> >> > Add support for core powergating on Calxeda platforms. Initially, this
> >> > supports ECX-1000 (highbank), but support will be added for ECX-2000
> >> > later.
> >> >
> >> > Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> >> > Cc: Len Brown <len.brown@intel.com>
> >> > Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> >>
> >> Acked-by: Arnd Bergmann <arnd@arndb.de>
> >>
> >> > It's not really clear where we want ARM cpuidle drivers. We're moving
> >> > everything else out of arch/arm, and my understanding is Len doesn't want
> >> > them in drivers/idle. It seems kind of silly to me to have the framework
> >> > and drivers in 2 places. I've put this in drivers/cpuidle, but it doesn't
> >> > make any difference to me.
> >>
> >> Fine with me. I just don't want in in arch/arm because I'm guessing this will
> >> be shared with arm64, which in turn shares idle (and other) drivers with various
> >> powerpc, mips and x86 socs.
> >
> > Applied to linux-pm.git/linux-next as v3.8 material.
> 
> We already have it in arm-soc. Since there's no maintainer listed for
> the directory, it didn't seem like there were any better merge paths.

Cool, I'll drop it then.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
