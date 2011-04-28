Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454Ab1D1MQD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 08:16:03 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:59146 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438Ab1D1MQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 08:16:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Joerg Roedel <joro@8bytes.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [RFC] ARM DMA mapping TODO, v1
Date: Thu, 28 Apr 2011 14:15:51 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linaro-mm-sig@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <201104212129.17013.arnd@arndb.de> <20110428102720.GA13402@8bytes.org>
In-Reply-To: <20110428102720.GA13402@8bytes.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104281415.51183.arnd@arndb.de>
X-Provags-ID: V02:K0:+VT+Jwd1viGkpPAiCRuI/T/cwM3aV12sBx0qnGO+F5p
 OHpHi8vIrf63VWI38FntmtMXLxKlsQ1suyOuvhZGSo+z7ACJSF
 +3Q2s9lphDG37rBVH6Sg4S7mb7vVTgJhPOBJoy1uCvthF235CW
 8WXs2nFThBk2mJavODn0pQ+q2xxkGKGMW9jOfFWQMc2zRSMdY3
 cyeNlIVN49goXh8ib5tKA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 April 2011, Joerg Roedel wrote:
> On Thu, Apr 21, 2011 at 09:29:16PM +0200, Arnd Bergmann wrote:
> > 4. Implement an architecture independent version of dma_map_ops
> >    based on the iommu.h API. As Joerg mentioned, this has been
> >    missing for some time, and it would be better to do it once
> >    than for each IOMMU separately. This is probably a lot of work.
> 
> Yes, thats missing for a long time. It will also need some changes to
> the IOMMU-API but that should be doable. The best would be to extend the
> IOMMU-API so that it also supports GART-like IOMMUs. This way every
> dma_ops implementation on all the architectures providing such an IOMMU
> could be covered with the architecture independent dma_ops
> implementation. This would only leave the low-level hardware access in
> the IOMMU drivers.
> I think this also requires to change the current semantics of the
> existing IOMMU-API implementations. I will prepare a write-up of my
> ideas for discussion.

Ok, thanks!

Please include Marek in this, he said he has already started with an
implementation. Any insight from you will certainly help.

	Arnd
