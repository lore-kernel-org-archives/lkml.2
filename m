Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283Ab1D2A34 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 20:29:56 -0400
Received: from gate.crashing.org ([63.228.1.57]:50942 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753070Ab1D2A3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 20:29:55 -0400
Subject: Re: [Linaro-mm-sig] [RFC] ARM DMA mapping TODO, v1
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jerome Glisse <j.glisse@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org, linux-arm-kernel@lists.infradead.org
In-Reply-To: <BANLkTinhm7ar1mf1D-dSMiLtw5hRNY36RA@mail.gmail.com>
References: <201104212129.17013.arnd@arndb.de>
	 <201104281428.56780.arnd@arndb.de>
	 <20110428131531.GK17290@n2100.arm.linux.org.uk>
	 <201104281629.52863.arnd@arndb.de>
	 <20110428143440.GP17290@n2100.arm.linux.org.uk>
	 <BANLkTinhm7ar1mf1D-dSMiLtw5hRNY36RA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Apr 2011 10:29:22 +1000
Message-ID: <1304036962.2513.202.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-28 at 15:37 -0400, Jerome Glisse wrote:
> Jesse also pointed out space exhaustion inside the iommu and i believe
> this should also be considered. This is why i believe the dma_* api is
> not well suited. In DRM/TTM we use  pci_dma_mapping* and we also play
> with with page set_page*_uc|wc|wb.

Which are yet another set of completely x86-centric APIs that have not
been thought in the context of other architectures and are probably
mostly unimplementables on half of them :-)

Cheers,
Ben.


