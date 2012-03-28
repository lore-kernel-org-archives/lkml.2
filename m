Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779Ab2C1IEX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 04:04:23 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:16753 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab2C1IEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 04:04:15 -0400
Date: Wed, 28 Mar 2012 10:04:08 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PULL REQUEST] DMA-mapping framework redesign preparation patches
In-reply-to: <20120213112145.4b8990c739d297cd30714d52@canb.auug.org.au>
To: "'Stephen Rothwell'" <sfr@canb.auug.org.au>
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>
Message-id: <00b701cd0cb9$5a4ea900$0eebfb00$%szyprowski@samsung.com>
Organization: SPRC
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
Thread-index: Aczp5YQaNDAJVIzYQkSE6rPXvNWpvgiypKsQ
References: <1328898737-15854-1-git-send-email-m.szyprowski@samsung.com>
 <20120213112145.4b8990c739d297cd30714d52@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Monday, February 13, 2012 1:22 AM Stephen Rothwell wrote:

> On Fri, 10 Feb 2012 19:32:17 +0100 Marek Szyprowski <m.szyprowski@samsung.com> wrote:
> >
> > Our patches with DMA-mapping framework redesign proposal have been
> > hanging for over a month with just a few comments. We would like to go
> > further in the development, but first I would like to ask You to give
> > them a try in the linux-next kernel.
> >
> > For everyone interested in this patch series, here is the relevant
> > thread: https://lkml.org/lkml/2011/12/23/97
> >
> > If there are any problems with our git tree, please contact Marek
> > Szyprowski <m.szyprowski@samsung.com> or alternatively Kyungmin Park
> > <kyungmin.park@samsung.com>.
> >
> > The following changes since commit 62aa2b537c6f5957afd98e29f96897419ed5ebab:
> >
> >   Linux 3.3-rc2 (2012-01-31 13:31:54 -0800)
> >
> > are available in the git repository at:
> >   git://git.infradead.org/users/kmpark/linux-samsung dma-mapping-next
> 
> I have added this from today.
> 
> Thanks for adding your subsystem tree as a participant of linux-next.  As
> you may know, this is not a judgment of your code.  The purpose of
> linux-next is for integration testing and to lower the impact of
> conflicts between subsystems in the next merge window.
> 
> You will need to ensure that the patches/commits in your tree/series have
> been:
>      * submitted under GPL v2 (or later) and include the Contributor's
> 	Signed-off-by,
>      * posted to the relevant mailing list,
>      * reviewed by you (or another maintainer of your subsystem tree),
>      * successfully unit tested, and
>      * destined for the current or next Linux merge window.
> 
> Basically, this should be just what you would send to Linus (or ask him
> to fetch).  It is allowed to be rebased if you deem it necessary.

I've prepared a separate git repository for all our dma-mapping related works. 
Could you update your database with the new entry? From now the dma-mapping 
updates will be available at:

git://git.linaro.org/people/mszyprowski/linux-dma-mapping.git dma-mapping-next

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center



