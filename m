Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918Ab1LVJZc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 04:25:32 -0500
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:37520 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751991Ab1LVJZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 04:25:27 -0500
MIME-Version: 1.0
In-Reply-To: <201112212314.39844.jkrzyszt@tis.icnet.pl>
References: <1323634328-856-1-git-send-email-jkrzyszt@tis.icnet.pl>
	<1323634328-856-8-git-send-email-jkrzyszt@tis.icnet.pl>
	<1324492424.8478.5.camel@odin>
	<201112212314.39844.jkrzyszt@tis.icnet.pl>
Date: Thu, 22 Dec 2011 09:25:26 +0000
Message-ID: <CABS+qY1Ng0JQMan++sG+T0jcCFOdDH61hzQ=AXyAD-BPDTpDFg@mail.gmail.com>
Subject: Re: [PATCH 07/10] ASoC: OMAP: ams-delta: Drive modem/codec pins over
 GPIO API
From: "Girdwood, Liam" <lrg@ti.com>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: Tony Lindgren <tony@atomide.com>, Jarkko Nikula <jarkko.nikula@bitmer.com>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 December 2011 22:14, Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> wrote:
> On Wednesday 21 of December 2011 at 19:33:44, Liam Girdwood wrote:
>> On Sun, 2011-12-11 at 21:12 +0100, Janusz Krzysztofik wrote:
>> > Don't use Amstrad Delta custom I/O functions any longer, replace them
>> > with GPIO. Old pin definitions, no longer used by the modem bits either,
>> > can be dropped.
>> >
>> > Depends on patch 2/10 "ARM: OMAP1: Convert Amstrad E3 latches to
>> > basic_mmio_gpio".
>> >
>> > Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
>>
>> Applied.
>
> Hi,
> I'm sorry, but I've probably missed to infrom you explicitly, i.e. other
> than in a cover letter to v2 of this series, that this particular patch
> has been dropped from the series. I've already started working on an
> alternative solution, which I intend to submit as a separate set. It
> will be free of potentail problems with two devices, a modem and the
> sound card, accessing the same GPIO pins concurrently. For the
> MODEM_NRESET pin I've already set up a virtual regulator on top of it,
> and for the MODEM_CODEC pin I'll probably choose a virtual clock (pinmux
> would match the hardware more closely here, but it looks too complicated
> to me). Moreover, I've already started to move all those GPIO pin
> related functions, i.e. bias control, digital mute and line discipline
> interaction, from the board file to the codec driver, where all those
> seem to belong.
>
> Having this patch applied will conflict with the regultor and the clock
> solutions, taking control over those two GPIO pins. Please revert this
> patch, or reset it if still possible.
>
> Thanks,
> Janusz

Will do, I never pushed last night as it was late. So I'll only will
have to make a local change.

Thanks

Liam
