Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab0G2Ife (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 04:35:34 -0400
Received: from sh.osrg.net ([192.16.179.4]:39710 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750938Ab0G2Ifc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 04:35:32 -0400
Date: Thu, 29 Jul 2010 17:35:10 +0900
To: arnd@arndb.de
Cc: fujita.tomonori@lab.ntt.co.jp, joerg.roedel@amd.com,
        stepanm@codeaurora.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, dwalker@codeaurora.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] arm: msm: Add System MMU support.
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <201007291026.55928.arnd@arndb.de>
References: <bad58db98c165a61860827d4e720acf8.squirrel@www.codeaurora.org>
	<20100729123512Y.fujita.tomonori@lab.ntt.co.jp>
	<201007291026.55928.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100729173431Q.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 29 Jul 2010 17:35:11 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Jul 2010 10:26:55 +0200
Arnd Bergmann <arnd@arndb.de> wrote:

> On Thursday 29 July 2010 05:35:48 FUJITA Tomonori wrote:
> > > 
> > > From what I have been able to tell, the IOMMU interface was written by
> > > AMD/Intel to allow the kvm code to work with a common IOMMU interface. To
> > 
> > Don't confuse the IOMMU interface with the DMA API that Arnd
> > mentioned.
> > 
> > They are not related at all.
> 
> Exactly, thanks for the clarification. I also didn't realize that there
> is now an include/linux/iommu.h file that only describes the PCI SR-IOV
> interfaces, unlike the generic IOMMU support that we have in your
> include/linux/dma-mapping.h file.
> 
> Maybe we should rename linux/iommu.h to something more specific so we
> can reduce this confusion in the future.

I also said that linux/iommu.h was a bad name when it was introduced
:) Well, the author disagreed. Now the name actually confuse
developers. The author might rethink.
