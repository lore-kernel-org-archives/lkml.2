Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab2GaLNN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 07:13:13 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47352 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755715Ab2GaLNL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 07:13:11 -0400
MIME-Version: 1.0
In-Reply-To: <CAK5ve-K5jh3cnm+T6VGp_njv7rLBMhFZsACFbYnkOu+Ortmbgg@mail.gmail.com>
References: <CAK5ve-JuZcjdbw_tV8vcriHWxOq1KFHm2mZBm6z3_j7hpPw-eA@mail.gmail.com>
 <CAK5ve-+3rKjeQA-WMQWvT48roFx-3Y-jNLZ3ciyOuH42x4Nu9A@mail.gmail.com>
 <CAOesGMgav2dqvUk623u_1ZuAE82drg2tF7rMpKMCZN4_Oq12_A@mail.gmail.com>
 <CAK5ve-K29fKi57hEWLh6gQ-F5KXXr7hHfyAkk_MebxcQf6Dp=A@mail.gmail.com>
 <20120731101502.GQ6802@n2100.arm.linux.org.uk> <CAK5ve-K5jh3cnm+T6VGp_njv7rLBMhFZsACFbYnkOu+Ortmbgg@mail.gmail.com>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Tue, 31 Jul 2012 19:12:50 +0800
X-Google-Sender-Auth: 0jQmCgp9jJHbYKFJPuXYKTOvfis
Message-ID: <CAK5ve-JYZgWQLz8if2KO3Wy0pTL2auLCyO2Ogjb_gvCsiucdUQ@mail.gmail.com>
Subject: Re: [GIT PULL] LED CPU trigger driver and ARM LED code consolidation
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 7:08 PM, Bryan Wu <bryan.wu@canonical.com> wrote:
> On Tue, Jul 31, 2012 at 6:15 PM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
>> On Tue, Jul 31, 2012 at 05:53:41PM +0800, Bryan Wu wrote:
>>> On Fri, Jun 8, 2012 at 4:20 PM, Olof Johansson <olof@lixom.net> wrote:
>>> > Hi,
>>> >
>>> > On Wed, Jun 6, 2012 at 11:12 PM, Bryan Wu <bryan.wu@canonical.com> wrote:
>>> >> Hi Arnd and Olof,
>>> >>
>>> >> Is there any chance to pull this LED code into ARM SoC tree?
>>> >>
>>> >> Thanks,
>>> >> -Bryan
>>> >>
>>> >> On Mon, Jun 4, 2012 at 3:25 PM, Bryan Wu <bryan.wu@canonical.com> wrote:
>>> >>> Hi Arnd and Olof,
>>> >>>
>>> >>> Please consider to pull my branch for LED CPU trigger driver and ARM
>>> >>> LED code consolidation, which is based on 3.5-rc1:
>>> >>>
>>> >>> The following changes since commit f8f5701bdaf9134b1f90e5044a82c66324d2073f:
>>> >>>
>>> >>>  Linux 3.5-rc1 (2012-06-02 18:29:26 -0700)
>>> >>>
>>> >>> are available in the git repository at:
>>> >>>
>>> >>>  git://git.kernel.org/pub/scm/linux/kernel/git/cooloney/linux-leds.git
>>> >>> for-arm-soc
>>> >
>>> > Pulled into arm-soc as devel/led-driver in next/drivers.
>>> >
>>> >
>>> > Thanks,
>>> >
>>> > -Olof
>>>
>>> Olof and Arnd,
>>>
>>> Will you guys send out pull request for this led-driver patches during
>>> this merge window?
>>
>> They're not, because you're ignoring bug reports against the patches.
>> They got dropped from arm-soc when I pointed out that they cause the
>> same old regression on Versatile platforms that I reported to you about
>> a year before.
>
> OMG， I missed such email, could you please point me out that?
>

Sorry for the mess, I got this email which was archived automatically.
I will try to fix this as soon as possible.

Thanks,
-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.186-168-78255 Mobile
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
