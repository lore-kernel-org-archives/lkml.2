Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160Ab2LTQzu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 11:55:50 -0500
Received: from mail-da0-f52.google.com ([209.85.210.52]:37821 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871Ab2LTQzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 11:55:44 -0500
Date: Thu, 20 Dec 2012 08:29:38 -0800
From: Olof Johansson <olof@lixom.net>
To: Tony Lindgren <tony@atomide.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>, arm@kernel.org,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [GIT PULL] ARM: arm-soc fixes for 3.8
Message-ID: <20121220162938.GA29578@quad.lixom.net>
References: <20121218065502.GA12865@quad.lixom.net>
 <50D08547.8040405@free-electrons.com>
 <20121220151059.GU4989@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121220151059.GU4989@atomide.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2012 at 07:10:59AM -0800, Tony Lindgren wrote:
> * Maxime Ripard <maxime.ripard@free-electrons.com> [121218 07:08]:
> > Hi Olof,
> > 
> > Le 18/12/2012 07:55, Olof Johansson a écrit :
> > > Maxime Ripard (1):
> > >       ARM: sunxi: Change device tree naming scheme for sunxi
> > 
> > There's something odd about this one (commit 68136b10). The patch that
> > you seem to have applied differs from the one I sent. The DTs files
> > appears to have not been renamed, while in the patch I sent
> > (http://lists.infradead.org/pipermail/linux-arm-kernel/2012-December/137105.html),
> > it's the case.
> > 
> > Do you know what happened here? What can we do to fix that?
> 
> Looks like that's trivial to fix as needed, no need to rebuild
> the branch to fix that AFAIK.
> 
> The fix can be done once Olof is available online again.
> 
> Linus, I suggest that you go ahead and pull this if there are
> no other issues with this branch.

Sorry for being offline a bit longer than expected. Fresh pull request
coming in a minute.


-Olof
