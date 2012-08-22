Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758729Ab2HVR63 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 13:58:29 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:41591 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755026Ab2HVR61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 13:58:27 -0400
Date: Wed, 22 Aug 2012 18:58:10 +0100
From: Will Deacon <will.deacon@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Russell King <rmk+kernel@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>
Subject: Re: [PATCH 1/4] ARM: export read_current_timer
Message-ID: <20120822175810.GT9093@mudshark.cambridge.arm.com>
References: <1345645780-2749-1-git-send-email-arnd@arndb.de>
 <1345645780-2749-2-git-send-email-arnd@arndb.de>
 <503513A2.1030002@codeaurora.org>
 <20120822174945.GS9093@mudshark.cambridge.arm.com>
 <50351D80.6010600@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50351D80.6010600@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 06:57:20PM +0100, Stephen Boyd wrote:
> On 08/22/12 10:49, Will Deacon wrote:
> > On the topic of the timer stuff: Shinya/Stephen, did you have a chance to
> > look at the registration stuff that was proposed? I'm happy to push it if
> > people will actually use it.
> 
> Yes I have tested it on our internal trees and it looks good. I plan to
> send a patch to move MSM's timers over to it later this week so that we
> have at least two users upstream.

Awesome, I'll dust that series off at -rc3 then.

Will
