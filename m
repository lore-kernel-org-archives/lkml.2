Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123Ab0IELW0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 07:22:26 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48885 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043Ab0IELWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 07:22:25 -0400
Date: Sun, 5 Sep 2010 12:21:53 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Eric Miao <eric.y.miao@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, khc@pm.waw.pl,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: fix pci_set_consistent_dma_mask for dmabounce
	devices
Message-ID: <20100905112152.GA558@n2100.arm.linux.org.uk>
References: <20100819174426O.fujita.tomonori@lab.ntt.co.jp> <m3sk1yzkjw.fsf@intrepid.localdomain> <20100901085738.GJ8142@n2100.arm.linux.org.uk> <20100902114937X.fujita.tomonori@lab.ntt.co.jp> <20100902055907.GA3287@riccoc20.at.omicron.at> <AANLkTi=TfmFPSfw3iYUMzxdsCLC7keJxMbb7vZvQHoiO@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=TfmFPSfw3iYUMzxdsCLC7keJxMbb7vZvQHoiO@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 05, 2010 at 06:50:17PM +0800, Eric Miao wrote:
> On Thu, Sep 2, 2010 at 1:59 PM, Richard Cochran
> <richardcochran@gmail.com> wrote:
> > On Thu, Sep 02, 2010 at 11:50:33AM +0900, FUJITA Tomonori wrote:
> >> btw, I can't compile ARCH_IXP4XX without the following patch:
> >>
> >> http://www.spinics.net/lists/arm-kernel/msg95933.html
> >
> > I have the same problem. Compilation of IXP4xx was broken by
> >
> >    commit 4fa5518c65df7a2c4b6c58061ac53d0b01228042
> >    Author: Eric Miao <eric.y.miao@gmail.com>
> >    Date:   Sat Jun 5 15:16:17 2010 +0800
> >
> >    [ARM] pxa: remove now unnecessary dma_needs_bounce()
> >
> > What is the correct way to do fix this? Is the above patch the
> > solution, or is dma_needs_bounce() perhaps also unnecessary for ixp?
> >
> 
> My bad to break this. If there is no quick proper fix, I'd prefer this
> being reverted first.

Reverted.

Can I assume that I can commit this with:

Reported-by: Richard Cochran <richardcochran@gmail.com>
Acked-by: Eric Miao <eric.y.miao@gmail.com>

?
