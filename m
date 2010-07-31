Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621Ab0GaDPn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 23:15:43 -0400
Received: from gate.crashing.org ([63.228.1.57]:35831 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754204Ab0GaDPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 23:15:41 -0400
Subject: Re: [PATCH 1/2] arm: msm: Add System MMU support.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Joerg Roedel <joerg.roedel@amd.com>, stepanm@codeaurora.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        dwalker@codeaurora.org, linux-kernel@vger.kernel.org
In-Reply-To: <201007291026.55928.arnd@arndb.de>
References: <ea4bbdecc271f7fa5749d09645f38c0d.squirrel@www.codeaurora.org>
	 <bad58db98c165a61860827d4e720acf8.squirrel@www.codeaurora.org>
	 <20100729123512Y.fujita.tomonori@lab.ntt.co.jp>
	 <201007291026.55928.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 31 Jul 2010 13:15:24 +1000
Message-ID: <1280546124.1902.30.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-29 at 10:26 +0200, Arnd Bergmann wrote:
> Exactly, thanks for the clarification. I also didn't realize that
> there
> is now an include/linux/iommu.h file that only describes the PCI
> SR-IOV
> interfaces, unlike the generic IOMMU support that we have in your
> include/linux/dma-mapping.h file.
> 
> Maybe we should rename linux/iommu.h to something more specific so we
> can reduce this confusion in the future.

Hrm, indeed I just noticed that. Pretty gross... it should definitly be
renamed, is will caused endless confusion with unrelated iommu.h and
iommu_* interfaces which represent something different.

Ben.


