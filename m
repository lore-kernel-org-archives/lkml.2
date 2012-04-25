Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758760Ab2DYCGN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 22:06:13 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:52247 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757318Ab2DYCGM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 22:06:12 -0400
MIME-Version: 1.0
In-Reply-To: <20120424195127.GA3628@n2100.arm.linux.org.uk>
References: <20120423062739.GX3852@pengutronix.de>
	<20120423065259.GR26306@S2101-09.ap.freescale.net>
	<20120423065623.GA3852@pengutronix.de>
	<20120423071013.GS26306@S2101-09.ap.freescale.net>
	<20120423074856.GU20478@pengutronix.de>
	<CAMXH7KH1pwh7hJ=T30zxcWcx19wjXvr6Ff4OLy7fzqY5p79Fwg@mail.gmail.com>
	<20120424013841.GB26306@S2101-09.ap.freescale.net>
	<20120424075426.GP24211@n2100.arm.linux.org.uk>
	<20120424083603.GE26306@S2101-09.ap.freescale.net>
	<CAMXH7KFMcHoGeTRcPWR_ENK2R=nU134HgjnXpFUsYJTL9pbgrQ@mail.gmail.com>
	<20120424195127.GA3628@n2100.arm.linux.org.uk>
Date: Wed, 25 Apr 2012 10:06:10 +0800
Message-ID: <CAAQ0ZWTR7PAFX6z6PpkBhGoy5qh6u-xjK16mVCHnSoi-0GrD3g@mail.gmail.com>
Subject: Re: [PATCH 1/3] ARM: imx: Add common imx cpuidle init functionality.
From: Shawn Guo <shawn.guo@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Rob Lee <rob.lee@linaro.org>, Sascha Hauer <s.hauer@pengutronix.de>,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        daniel.lezcano@linaro.org, linux-kernel@vger.kernel.org,
        Amit Kucheria <amit.kucheria@linaro.org>, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 April 2012 03:51, Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> On Tue, Apr 24, 2012 at 10:40:35AM -0500, Rob Lee wrote:
>> Thanks for the attention on this.  From what I've understood, I will
>> send another submission that includes the imx cpuidle patchset and
>> Shawn's device tree late initcall patchset and I'll provide
>> explanation of the two separate patchsets in the cover sheet.
>
> What I also want to see _along with_ the addition of the init_late
> callback is a patch set from the _same_ people fixing up the rest
> of arch/arm/mach-* to use it - you know, like what I do when I
> introduce these kinds of things.
>
> Otherwise I'm going to NAK the change.  We can't have new stuff
> introduced in this way and the older platforms ignored.  Forward
> progress across the board please.

I'm working on a series to clean them up.

Regards,
Shawn
