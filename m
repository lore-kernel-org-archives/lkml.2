Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598Ab1BYLbQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 06:31:16 -0500
Received: from service87.mimecast.com ([94.185.240.25]:48702 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754048Ab1BYLbP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 06:31:15 -0500
Subject: Re: [TRIVIAL/PATCH] ARM: hw_breakpoint: Fix newlines in WARN
 messages
From: Will Deacon <will.deacon@arm.com>
To: Lothar =?ISO-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Cc: Stephen Boyd <sboyd@codeaurora.org>, trivial@kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
In-Reply-To: <19815.20063.647326.437650@ipc1.ka-ro>
References: <1298573739-25144-1-git-send-email-sboyd@codeaurora.org>
	 <19815.20063.647326.437650@ipc1.ka-ro>
Date: Fri, 25 Feb 2011 11:31:06 +0000
Message-ID: <1298633466.32588.1.camel@e102144-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 25 Feb 2011 11:31:09.0957 (UTC) FILETIME=[7FF24350:01CBD4DF]
X-MC-Unique: 111022511311206201
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-25 at 06:38 +0000, Lothar Waßmann wrote:
> Hi,
> 
Hello,

> Stephen Boyd writes:
> > These warnings are missing newlines and spaces causing confusing
> > looking output when they trigger.
> >
> > Cc: Will Deacon <will.deacon@arm.com>
> > Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> > ---
> >  arch/arm/kernel/hw_breakpoint.c |   13 +++++++------
> >  1 files changed, 7 insertions(+), 6 deletions(-)
> >
> > diff --git a/arch/arm/kernel/hw_breakpoint.c b/arch/arm/kernel/hw_breakpoint.c
> > index d600bd3..5aab00e 100644
> > --- a/arch/arm/kernel/hw_breakpoint.c
> > +++ b/arch/arm/kernel/hw_breakpoint.c
> > @@ -238,8 +238,8 @@ static int enable_monitor_mode(void)
> >       ARM_DBG_READ(c1, 0, dscr);
> > 
> >       /* Ensure that halting mode is disabled. */
> > -     if (WARN_ONCE(dscr & ARM_DSCR_HDBGEN, "halting debug mode enabled."
> > -                             "Unable to access hardware resources.")) {
> > +     if (WARN_ONCE(dscr & ARM_DSCR_HDBGEN, "halting debug mode enabled. "
> > +                             "Unable to access hardware resources.\n")) {
> >
> I'd prefer the message text not to be line wrapped, even if it
> violates the general line length rule, because that makes it easier to
> grep for the message in the source code.


Ok, that's understandable. Moving the text onto its own line will limit
the damage to the line length too. Stephen - are you happy to make these
changes as part of your previous patch?

Thanks,

Will


