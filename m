Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872Ab1D0OxR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 10:53:17 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:47133 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752213Ab1D0OxP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 10:53:15 -0400
MIME-Version: 1.0
In-Reply-To: <20110427115133.GA16447@rainbow>
References: <20110411093214.GA18215@rainbow>
	<4DA3350E.2060400@gmail.com>
	<BANLkTinDMZ+CyGCmzZu8cSz1L_yFXxm+vg@mail.gmail.com>
	<112ef82aebc719ef25cde126f2014ebc@mail.gmail.com>
	<20110412040420.GB25239@rainbow>
	<bcd954a468e6a07bd673b7d0731e9344@mail.gmail.com>
	<4DB0D58E.4030508@signal11.us>
	<8712165194c49f0b4d8c1bd1fe717b8a@mail.gmail.com>
	<20110427115133.GA16447@rainbow>
Date: Wed, 27 Apr 2011 20:22:27 +0530
Message-ID: <BANLkTi=Sr7ROJ5tSY0=XxHhp6CPvyH2Dmw@mail.gmail.com>
Subject: Re: [Regression?] Removed regulator support in ehci-omap
From: "Munegowda, Keshava" <keshava_mgowda@ti.com>
To: Dmitry Artamonow <mad_soft@inbox.ru>
Cc: Alan Ott <alan@signal11.us>, Steve Sakoman <sakoman@gmail.com>,
        Steve Calfee <stevecalfee@gmail.com>, Felipe Balbi <balbi@ti.com>,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 5:21 PM, Dmitry Artamonow <mad_soft@inbox.ru> wrote:
> On 12:07 Sun 24 Apr     , Keshava Munegowda wrote:
>> I have posted the patches on April 22, 2011.
>> If possible I request you to test this.
>
> Hi, Keshava!
>
> Sorry for delay - it took some time to find _where_ exactly you have posted
> the patch (thanks to Alan for giving the link). Anyway, it[1] seems to work
> as advertised (I also applied GPIO polarity fix [2] and board file patch[3],
> all on top of 2.6.39-rc4) - at least stuff in /sys/class/regulator looks right,
> and USB devices are detected. There's probably something still missing in the
> board file, as USB detection starts to work only if I booted TI's kernel
> (that came with board) before trying patched 2.6.39-rc4, but I hope that
> this isn't connected to this regulators issue.
>
> [1] http://www.spinics.net/lists/linux-usb/msg45618.html
> [2] https://lkml.org/lkml/2011/4/14/45
> [3] http://arago-project.org/git/projects/?p=linux-omap3.git;a=commitdiff;h=2ec611981ad76256d5034ae36708d807142bed1c
>> --
> Best regards,
> Dmitry "MAD" Artamonow

I think I am missing something here! In which platform are you testing?
keshava munegowda

>
>
