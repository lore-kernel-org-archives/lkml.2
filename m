Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269Ab2AZXX3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 18:23:29 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51717 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323Ab2AZXX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 18:23:28 -0500
Date: Thu, 26 Jan 2012 23:23:04 +0000
From: Russell King <rmk@arm.linux.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: merge of the arm tree into the at91 tree
Message-ID: <20120126232304.GA10259@flint.arm.linux.org.uk>
References: <20120127093619.f2c90c6aa8b542134a157956@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120127093619.f2c90c6aa8b542134a157956@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 09:36:19AM +1100, Stephen Rothwell wrote:
> I noticed that the for-next branch of the arm tree has been merged into
> the at91 tree.  My understanding (and Russell, please correct me if I am
> wrong) is that the for-next branch is *not* stable and may be rebased.
> This will cause all sorts of problems in linux-next in the future (and
> also when Russell or the arm=soc guys merge the at91 tree into theirs).

And has already been rebuilt (I won't use 'rebased' because that's really
not what happens to it.)  I've already re-explained this to Nicolas.  It's
equivalent to someone basing their work off linux-next and expecting to
have that pulled into some other tree.

What's even worse is that Nicolas has published this as an official
branch for other people.

> In fact, I am going to have problems today as Russell has already rebase
> his for-next branch.  :-(

I suggest that you drop the at91 tree this time around if you get
conflicts.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
