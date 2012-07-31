Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab2GaKQ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 06:16:26 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52325 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732Ab2GaKQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 06:16:24 -0400
Date: Tue, 31 Jul 2012 11:15:02 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Bryan Wu <bryan.wu@canonical.com>
Cc: linux-arm-kernel@lists.infradead.org, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>
Subject: Re: [GIT PULL] LED CPU trigger driver and ARM LED code
	consolidation
Message-ID: <20120731101502.GQ6802@n2100.arm.linux.org.uk>
References: <CAK5ve-JuZcjdbw_tV8vcriHWxOq1KFHm2mZBm6z3_j7hpPw-eA@mail.gmail.com> <CAK5ve-+3rKjeQA-WMQWvT48roFx-3Y-jNLZ3ciyOuH42x4Nu9A@mail.gmail.com> <CAOesGMgav2dqvUk623u_1ZuAE82drg2tF7rMpKMCZN4_Oq12_A@mail.gmail.com> <CAK5ve-K29fKi57hEWLh6gQ-F5KXXr7hHfyAkk_MebxcQf6Dp=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK5ve-K29fKi57hEWLh6gQ-F5KXXr7hHfyAkk_MebxcQf6Dp=A@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 05:53:41PM +0800, Bryan Wu wrote:
> On Fri, Jun 8, 2012 at 4:20 PM, Olof Johansson <olof@lixom.net> wrote:
> > Hi,
> >
> > On Wed, Jun 6, 2012 at 11:12 PM, Bryan Wu <bryan.wu@canonical.com> wrote:
> >> Hi Arnd and Olof,
> >>
> >> Is there any chance to pull this LED code into ARM SoC tree?
> >>
> >> Thanks,
> >> -Bryan
> >>
> >> On Mon, Jun 4, 2012 at 3:25 PM, Bryan Wu <bryan.wu@canonical.com> wrote:
> >>> Hi Arnd and Olof,
> >>>
> >>> Please consider to pull my branch for LED CPU trigger driver and ARM
> >>> LED code consolidation, which is based on 3.5-rc1:
> >>>
> >>> The following changes since commit f8f5701bdaf9134b1f90e5044a82c66324d2073f:
> >>>
> >>>  Linux 3.5-rc1 (2012-06-02 18:29:26 -0700)
> >>>
> >>> are available in the git repository at:
> >>>
> >>>  git://git.kernel.org/pub/scm/linux/kernel/git/cooloney/linux-leds.git
> >>> for-arm-soc
> >
> > Pulled into arm-soc as devel/led-driver in next/drivers.
> >
> >
> > Thanks,
> >
> > -Olof
> 
> Olof and Arnd,
> 
> Will you guys send out pull request for this led-driver patches during
> this merge window?

They're not, because you're ignoring bug reports against the patches.
They got dropped from arm-soc when I pointed out that they cause the
same old regression on Versatile platforms that I reported to you about
a year before.
