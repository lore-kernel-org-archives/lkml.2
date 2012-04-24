Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726Ab2DXPk6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 11:40:58 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57751 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755118Ab2DXPk5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 11:40:57 -0400
MIME-Version: 1.0
In-Reply-To: <20120424083603.GE26306@S2101-09.ap.freescale.net>
References: <CAMXH7KE2RtdNy3G61guZb2uWy3rn267Z3eEVEgN5e==tHHsiuA@mail.gmail.com>
 <20120423051813.GM26306@S2101-09.ap.freescale.net> <20120423062739.GX3852@pengutronix.de>
 <20120423065259.GR26306@S2101-09.ap.freescale.net> <20120423065623.GA3852@pengutronix.de>
 <20120423071013.GS26306@S2101-09.ap.freescale.net> <20120423074856.GU20478@pengutronix.de>
 <CAMXH7KH1pwh7hJ=T30zxcWcx19wjXvr6Ff4OLy7fzqY5p79Fwg@mail.gmail.com>
 <20120424013841.GB26306@S2101-09.ap.freescale.net> <20120424075426.GP24211@n2100.arm.linux.org.uk>
 <20120424083603.GE26306@S2101-09.ap.freescale.net>
From: Rob Lee <rob.lee@linaro.org>
Date: Tue, 24 Apr 2012 10:40:35 -0500
Message-ID: <CAMXH7KFMcHoGeTRcPWR_ENK2R=nU134HgjnXpFUsYJTL9pbgrQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] ARM: imx: Add common imx cpuidle init functionality.
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Sascha Hauer <s.hauer@pengutronix.de>, linaro-dev@lists.linaro.org,
        patches@linaro.org, daniel.lezcano@linaro.org,
        linux-kernel@vger.kernel.org, Amit Kucheria <amit.kucheria@linaro.org>,
        kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2012 at 3:36 AM, Shawn Guo <shawn.guo@linaro.org> wrote:
> On Tue, Apr 24, 2012 at 08:54:26AM +0100, Russell King - ARM Linux wrote:
>> On Tue, Apr 24, 2012 at 09:38:43AM +0800, Shawn Guo wrote:
>> > On Mon, Apr 23, 2012 at 10:45:02AM -0500, Rob Lee wrote:
>> > > >> Let me try last time.  What about having a late_initcall hook in
>> > > >> machine_desc?
>> > > >
>> > > > Also fine with me.
>> > > >
>> > >
>> > > Shall I add Shawn's patch to my imx cpuidle patchset or should the
>> > > arch/arm/kernel/setup.c and arch.h changes be submitted separately?
>> > > If separately, Shawn, did you want to submit this patch or should I?
>> > >
>> > Strange.  Russell is not in the Cc list.  I remember I added Russell
>> > into Cc when I propose the idea.  Added him again.
>>
>> I didn't see any message in this thread cc'd to me, but that's not to
>> say I hadn't already read this patch.  I don't have any comment against
>> it, but I do wonder how often this hook would be used.
>>
> I guess mach-* that use common cpuidle will likely need this hook.
>
>> We do seem to have quite a number of late_initcall()s in arch/arm/mach-*,
>> so it seems to be a good idea - provided someone's willing to convert all
>> those users of late_initcall()s.
>
> Agreed.  The late_initcall()s in arch/arm/mach-* will not scale for
> long time, since we are moving toward single build.
>

Thanks for the attention on this.  From what I've understood, I will
send another submission that includes the imx cpuidle patchset and
Shawn's device tree late initcall patchset and I'll provide
explanation of the two separate patchsets in the cover sheet.

> --
> Regards,
> Shawn
