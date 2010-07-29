Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604Ab0G2I1b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 04:27:31 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:65484 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754408Ab0G2I11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 04:27:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH 1/2] arm: msm: Add System MMU support.
Date: Thu, 29 Jul 2010 10:26:55 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc4-next-20100709+; KDE/4.4.90; x86_64; ; )
Cc: stepanm@codeaurora.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, dwalker@codeaurora.org,
        linux-kernel@vger.kernel.org
References: <ea4bbdecc271f7fa5749d09645f38c0d.squirrel@www.codeaurora.org> <bad58db98c165a61860827d4e720acf8.squirrel@www.codeaurora.org> <20100729123512Y.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100729123512Y.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007291026.55928.arnd@arndb.de>
X-Provags-ID: V02:K0:uQfZNwR+/kwqpb1SfIR1OcJBfkeJwaFGiRs13b8jguI
 BO8qeFxX4Wk92tzv/rQ/iykmr8RpjynL9/8qZx+WBKvsTPDUJO
 tB5VhD+xHWX8SZdk7s7n5pxBoL1iDSG1nzD+795hAPinDWlumC
 egS/aaQQylfUUCBPRe4xw0OYHzpR7MCe+vqVxnhyyUyRDW53+7
 GM2Mp+R7ne5E/3k0cwVWQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 July 2010 05:35:48 FUJITA Tomonori wrote:
> > 
> > From what I have been able to tell, the IOMMU interface was written by
> > AMD/Intel to allow the kvm code to work with a common IOMMU interface. To
> 
> Don't confuse the IOMMU interface with the DMA API that Arnd
> mentioned.
> 
> They are not related at all.

Exactly, thanks for the clarification. I also didn't realize that there
is now an include/linux/iommu.h file that only describes the PCI SR-IOV
interfaces, unlike the generic IOMMU support that we have in your
include/linux/dma-mapping.h file.

Maybe we should rename linux/iommu.h to something more specific so we
can reduce this confusion in the future.

	Arnd
