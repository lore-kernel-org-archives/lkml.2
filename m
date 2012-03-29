Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933425Ab2C2Xma (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 19:42:30 -0400
Received: from joshcartwright.net ([69.164.192.171]:56397 "EHLO
	li107-171.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932551Ab2C2Xm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 19:42:26 -0400
Date: Thu, 29 Mar 2012 19:29:29 -0400
From: Josh Cartwright <joshc@linux.com>
To: Brian Norris <computersforpeace@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: [PATCH] jffs2: Fix lock acquisition order bug in gc path
Message-ID: <20120329232929.GA21848@joshcartwright.net>
References: <20120209185043.GA12089@joshcartwright.net>
 <CAN8TOE-9fxbc8PM8oNVBc_tUdkYBhV6jTG8_M5GdjLNGpLhKKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAN8TOE-9fxbc8PM8oNVBc_tUdkYBhV6jTG8_M5GdjLNGpLhKKA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 08:38:41AM -0700, Brian Norris wrote:
> On Thu, Feb 9, 2012 at 10:50 AM, Josh Cartwright <joshc@linux.com> wrote:
> > The locking policy is such that the erase_complete_block spinlock is
> > nested within the alloc_sem mutex.  This fixes a case in which the
> > acquisition order was erroneously reversed.  This issue was caught by
> > the following lockdep splat:
> 
> (Bump.) Anybody interested in this patch? It seemed sane to me, and I
> had it sitting in my inbox. It does need a trivial rebase, BTW.

I'm certainly still interested in it, for what its worth :).  We've had
no problems here for the month and a half its been in our tree.

I'll send out a rebased V2.

Thanks!

-- 
                                            joshc

