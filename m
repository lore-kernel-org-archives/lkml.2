Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933711Ab0HFFPH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 01:15:07 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:62437 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107Ab0HFFPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 01:15:03 -0400
Date: Fri, 06 Aug 2010 14:15:07 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: RE: linux-next: manual merge of the input tree with the s5p tree
In-reply-to: <4C5B7F7A.1000707@samsung.com>
To: "'Joonyoung Shim'" <jy0922.shim@samsung.com>
Cc: "'Stephen Rothwell'" <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Dmitry Torokhov'" <dmitry.torokhov@gmail.com>
Message-id: <006e01cb3526$592816e0$0b7844a0$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=UTF-8
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: Acs1FlAflJsx+5ImQ/+DMtMFNLg5hAACm1xg
References: <20100722114655.1140fb61.sfr@canb.auug.org.au>
 <20100806102419.3e875933.sfr@canb.auug.org.au>
 <004801cb3500$69824bd0$3c86e370$%kim@samsung.com>
 <20100806114314.6d15d4fb.sfr@canb.auug.org.au> <4C5B7F7A.1000707@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joonyoung Shim wrote:
> 
> On 8/6/2010 10:43 AM, Stephen Rothwell wrote:
> > Hi,
> >
> > On Fri, 06 Aug 2010 09:43:34 +0900 Kukjin Kim <kgene.kim@samsung.com>
> wrote:
> >> I know that Dmitry's 'Input: samsung-keypad...patch' which includes
> >> plat/keypad.h has been merged Linus' tree in this merge window.
> >> And Joonyoung's another patch which is in my tree needs to update it, but my
> >> tree is don't having it against Linus' 2.6.35.
> >>
> >> So happened conflict...how can/should I handle this...
> >> Should I rebase my tree against Linus' latest?
> >
> > Either rebase (worst), or just merge Linus' tree (better) into yours or
> > (best) merge what Dmitry merged into Linus' tree.  To do this last, you
> > need to merge commit d01d0756f75e7a5b4b43764ad45b83c4340f11d6 from
> Linus'
> > tree.  Doing this brings in the minimum amount of extra stuff to your
> > tree, but allows you to sort out the conflict.
> >
> 
> Kukjin,
> 
> If you rebase and need, i can send updated patches. It uses "ARM:
> SAMSUNG: Add helper to clone and set platform data" patch of Ben Dooks.
> 
> Thanks.

Ok...please send it in today.

I have a plan to send 'pull request' to Russell in this weekend or the beginning of next week.

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

