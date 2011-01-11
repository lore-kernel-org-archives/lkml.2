Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202Ab1AKNdk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 08:33:40 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:48716 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932138Ab1AKNdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 08:33:36 -0500
Date: Tue, 11 Jan 2011 14:33:35 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm: mm: Poison freed init memory
Message-ID: <20110111133335.GE10705@atrey.karlin.mff.cuni.cz>
References: <1294256845-29517-1-git-send-email-sboyd@codeaurora.org> <20110105202645.GL8638@n2100.arm.linux.org.uk> <4D255263.7040106@codeaurora.org> <20110106090741.GQ8638@n2100.arm.linux.org.uk> <4D2BE3E1.5060706@codeaurora.org> <20110111090615.GH12552@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110111090615.GH12552@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Ok it seems that 0xcc was chosen by Pavel since it's a breakpoint
> > instruction (sorry for not noticing that earlier [1]).
> 
> It may be on x86, but on ARM:
> 
>    0:   cccccccc        stclgt  12, cr12, [ip], {204}
> 
> That's a co-processor #12 instruction which will only be executed of
> the processor condition codes satisfy 'gt'.
> 
> > There was some discussion about handling initdata with Pavel's patch
> > but it seems that nothing came of it?
> 
> I'm not sure who this Pavel is who you keep referring to - the message
> you link to is a discussion between William Irvin and hpa.

I was surprised, too, but it looks like I was the one who ported patch
from x86-64.

I'm not really sure if initdata poisoning happened... it is too long
ago.

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
