Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934763Ab1JaWzl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 18:55:41 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:35644 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934704Ab1JaWzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 18:55:40 -0400
Subject: Re: [PATCH 00/17] drop unused Kconfig symbols
From: Paul Bolle <pebolle@tiscali.nl>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, Jesper Nilsson <jesper.nilsson@axis.com>,
        Mikael Starvik <starvik@axis.com>,
        "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
        Paul Mundt <lethal@linux-sh.org>
In-Reply-To: <20111031224248.GB25411@sepie.suse.cz>
References: <1319456255.2409.30.camel@x61.thuisdomein>
	 <20111031224248.GB25411@sepie.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 Oct 2011 23:55:16 +0100
Message-ID: <1320101716.14409.97.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-31 at 23:42 +0100, Michal Marek wrote:
> On Mon, Oct 24, 2011 at 01:37:35PM +0200, Paul Bolle wrote:
> > 1) I've dropped five patches that were taken by the maintainers
> > (blackfin, unicore32, tomoyo, m68k, and staging). cris got a NAK (for an
> > invalid reason, but I guess I'll just try again after the v3.2 merge
> > window closes).

Just today Jesper Nilsson basically dropped that NAK. I assume Jesper
will try to carry the patch in (one of) their tree(s). Is that correct?

> > 4) I'll send these patches only to you and the people that added a tag.
> > Please tell me if you'd like me to also cc lkml and the maintainers. I
> > assumed cc'ing those addresses would not be helpful in this stage.
> > 
> > Paul Bolle (17):
> >   alpha: drop unused Kconfig symbol
> >   sparc: drop unused Kconfig symbol
> >   um: drop unused Kconfig symbol
> >   sh: drop unused Kconfig symbol

Paul Mundt applied this one a few days ago. But I think git merge will
handle that somewhere down the road.

> >   score: drop unused Kconfig symbols
> >   m32r: drop unused Kconfig symbol
> >   samples: drop unused Kconfig symbol
> >   arm: at91: drop unused Kconfig symbol
> >   (arm: drop unused Kconfig symbol -- skipped)
> >   openrisc: drop unused Kconfig symbols
> >   mips: drop unused Kconfig symbols
> >   powerpc: 40x: drop unused Kconfig symbol
> >   powerpc: drop unused Kconfig symbols
> >   x86: drop unused Kconfig symbol
> >   stmmac: drop unused Kconfig symbol
> >   pci: drop unused Kconfig symbol
> >   scsi: drop unused Kconfig symbol
> 
> Applied except for the one arm commit.


Paul Bolle

