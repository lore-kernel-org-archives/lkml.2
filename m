Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514Ab2AEAqX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 19:46:23 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:51962 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757264Ab2AEAqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 19:46:21 -0500
X-AuditID: cbfee61a-b7b89ae000001a15-d9-4f04f2ccaaa5
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Russell King'" <rmk@arm.linux.org.uk>,
        "'Stephen Rothwell'" <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20120104131830.ec4341de50a69f4f3f2c5b7b@canb.auug.org.au>
 <20120104090702.GA28052@flint.arm.linux.org.uk>
In-reply-to: <20120104090702.GA28052@flint.arm.linux.org.uk>
Subject: RE: linux-next: manual merge of the s5p tree with the arm tree
Date: Thu, 05 Jan 2012 09:46:02 +0900
Message-id: <00bf01cccb43$667542f0$335fc8d0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AczKwEnxS04g+8tfQOKtUs0Pfe1MrwAgk+fA
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King wrote:
> 
> On Wed, Jan 04, 2012 at 01:18:30PM +1100, Stephen Rothwell wrote:
> > Hi Kukjin,
> >
> > Today's linux-next merge of the s5p tree got a conflict in
> > arch/arm/plat-samsung/include/plat/system-reset.h between commit
> > 281c8724c10c ("ARM: restart: Temporary #error to persuade platform
> > maintainers to take the restart changes seriously") from the arm tree
> and
> > commit 08c6fc52956c ("ARM: restart: EXYNOS: use new restart hook") from
> > the s5p tree.
> >
> > The arm tree patch seems to have had the desired affect so I used the
> s5p
> > tree version.
> 
> Err, what are the Samsung people playing at, merging the patches that
> they've sent me for merging into their own tree?
> 
Russell, no. They will be removed in my tree.

> This is a recipe for breakage, especially as the exynos patch depends
> on previous patches in my tree _and_ patches in my tree depend on that
> patch as well.
> 
Yes, you're right. So they should be sent to upstream via arm tree.

> Well, we'll see what we end up with when you do the next linux-next,
> as by then my public tree should be updated with yesterdays work by
> then.
> 
> I've a feeling that this coming merge window is going to be a horrible
> mess.
> 

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

