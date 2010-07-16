Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758966Ab0GPTJ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 15:09:56 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:55106 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756804Ab0GPTJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 15:09:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=GD53IlPsbSMvHlPKNzFSNvITEPHItTgwPY9gUg3czf6o7HIrZ7B81f+z0yLfeAIT+5mD2goOuiSOAQKwi9K1iwff36yAUTA1XRCMUtGfARViOAuUklMaTAz8DSYgXdlZ;
Date: Fri, 16 Jul 2010 12:09:54 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pci: remove unused
 HAVE_ARCH_PCI_SET_DMA_MAX_SEGMENT_{SIZE|BOUNDARY}
Message-ID: <20100716120954.7c777e1d@virtuousgeek.org>
In-Reply-To: <20100712155845E.fujita.tomonori@lab.ntt.co.jp>
References: <20100712155845E.fujita.tomonori@lab.ntt.co.jp>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Jul 2010 15:59:11 +0900
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> In 2.6.34, we transformed the PCI DMA API into the generic device
> mode. The PCI DMA API is just the wrapper of the DMA API.
> 
> So we don't need HAVE_ARCH_PCI_SET_DMA_MAX_SEGMENT_SIZE or
> HAVE_ARCH_PCI_SET_DMA_SEGMENT_BOUNDARY (which enable architectures to
> have the own implementations). Both haven't been used anyway.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  drivers/pci/pci.c |    4 ----

Applied to my linux-next branch, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
