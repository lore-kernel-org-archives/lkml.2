Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972Ab2KUO7Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 09:59:16 -0500
Received: from mail.free-electrons.com ([88.190.12.23]:41507 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754911Ab2KUO7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 09:59:15 -0500
Date: Wed, 21 Nov 2012 15:59:03 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Axel Lin <axel.lin@ingics.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] Dove pinctrl fixes and DT enabling
Message-ID: <20121121155903.17f3e9cf@skate>
In-Reply-To: <CACRpkdYzQuv8sPk57CvqiwMmV0z007cGqVkGOENmr_aYAN14=Q@mail.gmail.com>
References: <1353317996-20841-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<CACRpkdYAnNCFDCjA67r0h_CSHMifb1Z83YJfYGQV3abPB8uQZg@mail.gmail.com>
	<50ACAAF5.2030002@gmail.com>
	<CACRpkdYzQuv8sPk57CvqiwMmV0z007cGqVkGOENmr_aYAN14=Q@mail.gmail.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

On Wed, 21 Nov 2012 15:45:42 +0100, Linus Walleij wrote:

> > I am referring to patches for a pinctrl/mvebu subfolder. IIRC Thomas
> > posted that patch a while ago. Jason is currently sorting things out
> > for mvebu pull requests. I guess both can comment on your question,
> > as I don't fully understand it.
> 
> So what I mean is that the patches creating pinctrl/mvebu is in the
> pinctrl tree, so if patches in the MVEBU tree depend on these,
> then it must have pulled in a branch from pinctrl or applied the
> same patches in that tree too (which is OK *sometimes*).

I know there has been some discussion between Arnd and Jason Cooper
(who handles the pull requests for the overall mvebu effort) about this
specific topic. I think the outcome of the discussion was that Jason
would have to see how much the rest of the mvebu stuff depends on this
pinctrl/mvebu change and will see with Arnd how to proceed. But it's
certainly better if Jason gives you directly feedback about this.

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
