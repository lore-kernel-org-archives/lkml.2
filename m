Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492Ab1HYQjq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 12:39:46 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44277 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485Ab1HYQjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 12:39:42 -0400
Date: Thu, 25 Aug 2011 17:39:01 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jon Medhurst <tixy@yxit.co.uk>
Subject: Re: linux-next: manual merge of the moduleh tree with the arm tree
Message-ID: <20110825163901.GA467@flint.arm.linux.org.uk>
References: <20110825151748.8e41e0ded739187a1432cf0b@canb.auug.org.au> <4E56796F.8090703@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E56796F.8090703@windriver.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 12:33:51PM -0400, Paul Gortmaker wrote:
> On 11-08-25 01:17 AM, Stephen Rothwell wrote:
> > Hi Paul,
> > 
> > Today's linux-next merge of the moduleh tree got a conflict in
> > arch/arm/mach-bcmring/mm.c between commit 2d5e975b2194 ("ARM:
> > mach-bcmring: Setup consistent dma size at boot time") from the arm tree
> > and commit 9bc7d81e271e ("arm: fix implicit use of page.h in
> > mach-bcmring/mach-jornada") from the moduleh tree.
> 
> I can't really relocate the page.h inclusion in a trivial way to
> make this conflict go away.  But since the implicit header use fixes
> for arm are independent and don't actually depend on anything in the
> rest of the module.h tree, I can set about to giving these to Russell
> for his arm-next branch anytime.  I'll do that shortly.

For such a trivial conflict, I don't think we need to do anything.  Linus
has said publically that he likes to sort out conflicts as it allows him
to have a wider knowledge of what's going on in the kernel tree.

So, given that the fixup is soo obvious, I don't think we need to play
games redistributing patches - we just need to be aware of the conflict
and mention it to Linus when we merge.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
