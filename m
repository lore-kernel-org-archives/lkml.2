Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474Ab2HVRuR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 13:50:17 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:41313 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754099Ab2HVRuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 13:50:13 -0400
Date: Wed, 22 Aug 2012 18:49:45 +0100
From: Will Deacon <will.deacon@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Russell King <rmk+kernel@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>
Subject: Re: [PATCH 1/4] ARM: export read_current_timer
Message-ID: <20120822174945.GS9093@mudshark.cambridge.arm.com>
References: <1345645780-2749-1-git-send-email-arnd@arndb.de>
 <1345645780-2749-2-git-send-email-arnd@arndb.de>
 <503513A2.1030002@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <503513A2.1030002@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 06:15:14PM +0100, Stephen Boyd wrote:
> On 08/22/12 07:29, Arnd Bergmann wrote:
> > read_current_timer is used in the get_cycles() function when
> > ARM_ARCH_TIMER is set, and that function can be inlined into
> > driver modules, so we should export the function to avoid
> > errors like
> >
> > ERROR: "read_current_timer" [drivers/video/udlfb.ko] undefined!
> > ERROR: "read_current_timer" [crypto/tcrypt.ko] undefined!
> >
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > Cc: Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>
> 
> Acked-by: Stephen Boyd <sboyd@codeaurora.org>
> 
> I ran into this last week but forgot to send the patch. Thanks.

Looks good to me, thanks Arnd:

Acked-by: Will Deacon <will.deacon@arm.com>

On the topic of the timer stuff: Shinya/Stephen, did you have a chance to
look at the registration stuff that was proposed? I'm happy to push it if
people will actually use it.

Cheers,

Will
