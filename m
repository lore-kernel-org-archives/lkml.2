Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932372Ab1ISVZR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 17:25:17 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:39374 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932097Ab1ISVZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 17:25:16 -0400
Date: Mon, 19 Sep 2011 22:25:02 +0100
From: Will Deacon <will.deacon@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/2] ARM: debug: Add CLSP711X_UART1 config choice
Message-ID: <20110919212502.GB23613@e102144-lin.cambridge.arm.com>
References: <20110916114140.GA31334@e102144-lin.cambridge.arm.com>
 <1316455300-5752-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316455300-5752-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Mon, Sep 19, 2011 at 07:01:39PM +0100, Stephen Boyd wrote:
> ARM patch 7072/1 (debug: use kconfig choice for selecting
> DEBUG_LL UART) only allowed CLSP711X_UART2 to be selected because
> there is no NONE option in a choice menu. Add a UART1 choice so
> that users can still choose UART1 explicitly.
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
> 
> On 09/16/11 04:41, Will Deacon wrote:
> > Ah yes. This will need to be added as part of the platform updates to go via
> > Arnd. It should be easy enough just to have a DEBUG_CLPS711X_UART1 option,
> > for example, and the platform code will fall back to the first UART.
> 
> I couldn't find these patches applied in Arnd's tree so I based it off of
> Russell's for-next branch.

Thanks for cooking the patch, it was somewhere on my list of things to do
this week! I think we also need to fix the DEBUG_DC21285_PORT option as that
has a similar `if not selected then use a different UART' behaviour. It can be
fixed in the same way as you have done in this patch.

Would you like me to take the three patches in with the ones I currently
have for other platforms (Realview, Samsung, imx) or would you prefer to
handle these separately? I was planning to send all of the platform bits to
Arnd once I've got my branches sorted out (been on holiday for the past two
weeks).

Cheers,

Will
