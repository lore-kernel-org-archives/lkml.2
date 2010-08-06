Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757245Ab0HFEd0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 00:33:26 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:41173 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab0HFEdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 00:33:21 -0400
Date: Fri, 06 Aug 2010 13:33:27 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: RE: linux-next: manual merge of the input tree with the s5p tree
In-reply-to: <20100806114314.6d15d4fb.sfr@canb.auug.org.au>
To: "'Stephen Rothwell'" <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Joonyoung Shim'" <jy0922.shim@samsung.com>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Dmitry Torokhov'" <dmitry.torokhov@gmail.com>,
        "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>
Message-id: <006b01cb3520$869ca6f0$93d5f4d0$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: Acs1CMKJEpyKBoNRRdOjhT0egl3W0AAFQ6Hg
References: <20100722114655.1140fb61.sfr@canb.auug.org.au>
 <20100806102419.3e875933.sfr@canb.auug.org.au>
 <004801cb3500$69824bd0$3c86e370$%kim@samsung.com>
 <20100806114314.6d15d4fb.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> 
> Hi,
> 
> On Fri, 06 Aug 2010 09:43:34 +0900 Kukjin Kim <kgene.kim@samsung.com>
wrote:
> >
> > I know that Dmitry's 'Input: samsung-keypad...patch' which includes
> > plat/keypad.h has been merged Linus' tree in this merge window.
> > And Joonyoung's another patch which is in my tree needs to update it,
but my
> > tree is don't having it against Linus' 2.6.35.
> >
> > So happened conflict...how can/should I handle this...
> > Should I rebase my tree against Linus' latest?
> 
> Either rebase (worst), or just merge Linus' tree (better) into yours or
> (best) merge what Dmitry merged into Linus' tree.  To do this last, you
> need to merge commit d01d0756f75e7a5b4b43764ad45b83c4340f11d6 from Linus'
> tree.  Doing this brings in the minimum amount of extra stuff to your
> tree, but allows you to sort out the conflict.
> 
Thanks for your kindly reply.

I will merge Dmitry's merge commit that you inform to me in my tree.
Then, conflict may be not happened tomorrow. :-)

Cc'ed Russell...

I wonder...as you know, my tree will going to upstream through Russell's
tree...if his tree doesn't having it, is it no problem when he merges my
tree?
I mean, is it no problem that there are Dmitry's stuff which has been merged
into Linus' in my tree when I'm sending 'pull request' to Russell?

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

