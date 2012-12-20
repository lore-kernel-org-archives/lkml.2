Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751337Ab2LTPLL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 10:11:11 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:55140 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750913Ab2LTPLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 10:11:07 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+Pcug0ElEWum6e8ZLbyEvI
Date: Thu, 20 Dec 2012 07:10:59 -0800
From: Tony Lindgren <tony@atomide.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Olof Johansson <olof@lixom.net>, arm@kernel.org,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [GIT PULL] ARM: arm-soc fixes for 3.8
Message-ID: <20121220151059.GU4989@atomide.com>
References: <20121218065502.GA12865@quad.lixom.net>
 <50D08547.8040405@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <50D08547.8040405@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Maxime Ripard <maxime.ripard@free-electrons.com> [121218 07:08]:
> Hi Olof,
> 
> Le 18/12/2012 07:55, Olof Johansson a écrit :
> > Maxime Ripard (1):
> >       ARM: sunxi: Change device tree naming scheme for sunxi
> 
> There's something odd about this one (commit 68136b10). The patch that
> you seem to have applied differs from the one I sent. The DTs files
> appears to have not been renamed, while in the patch I sent
> (http://lists.infradead.org/pipermail/linux-arm-kernel/2012-December/137105.html),
> it's the case.
> 
> Do you know what happened here? What can we do to fix that?

Looks like that's trivial to fix as needed, no need to rebuild
the branch to fix that AFAIK.

The fix can be done once Olof is available online again.

Linus, I suggest that you go ahead and pull this if there are
no other issues with this branch.

Regards,

Tony
