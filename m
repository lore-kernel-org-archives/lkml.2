Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964952Ab1CaB5K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 21:57:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48139 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755494Ab1CaB5I convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 21:57:08 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTimS_8BnBz9MSdxYJVL6oreEpH=W61BsyuX2G+Xz@mail.gmail.com>
References: <20110317183048.GW7258@atomide.com> <AANLkTimWbb5DWiiCW821H6pRicbk1fS3PYcnGyUMznvM@mail.gmail.com>
 <20110318101512.GA15375@n2100.arm.linux.org.uk> <201103301906.42429.arnd@arndb.de>
 <AANLkTim578-kwM14SJd06RW_QiC4WVCmFuG+ASgGC4sq@mail.gmail.com>
 <20110331001502.GB6680@n2100.arm.linux.org.uk> <AANLkTinE7EDbV8hrYZWBxgvwOxdPMLoS0Y57PSm04rvM@mail.gmail.com>
 <AANLkTik-BFTzyPLuYVdhCJPocc0wPY0rKvO7BQS4Fg1S@mail.gmail.com>
 <AANLkTikd_JRxmB_OWZqq178=K3bnxhdDqcNbgFNRtTyU@mail.gmail.com> <AANLkTimS_8BnBz9MSdxYJVL6oreEpH=W61BsyuX2G+Xz@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 30 Mar 2011 18:56:19 -0700
Message-ID: <AANLkTimtO7vR2AQvJj1hHMqHCDqtoiJX_eENE9o3dPpV@mail.gmail.com>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
To: Bill Gatliff <bgat@billgatliff.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        David Brown <davidb@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Nicolas Pitre <nico@fluxnic.net>,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 6:44 PM, Bill Gatliff <bgat@billgatliff.com> wrote:
>
> In the meantime, we have to live with the chips that exist and the
> ones coming down the pipe.  Until ARM and all their licensees start
> consulting us on such matters, we'll just have to find a way to deal
> with what we're given after the fact.

Yes. But:

 (a) we don't have to be stupid and think it's a good design and an
"opportunity" like you do.

and

 (b) the kernel source code doesn't have to be the mess of code that
it is. Those things should be abstracted out somehow (and yes,
devicetree is hopefully one way)

I really don't understand why you seem to be arguing against trying to
fix a real problem, and why you also seem to be arguing that the messy
ARM situation is somehow "good". I find your attitude about the lack
of platform being "good" be to incomprehensibly stupid. There is
absolutely _no_ advantage to anybody from the crazy arm fragmentation.

I know, I know, a lot of companies make money supporting the whole
crazy mess. I guess that can make people confused and think that being
messy is good, and could be seen as an advantage.

But most embedded companies seem to have realized that they should
move up the stack, rather than worry about some crazy GPIO or stupid
driver details.

                Linus
