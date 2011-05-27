Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647Ab1E0Pz2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 11:55:28 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:22942 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845Ab1E0Pz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 11:55:27 -0400
Date: Fri, 27 May 2011 11:55:07 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Daniel Haid <d.haid@gogi.tv>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: Question about iommu on x86_64 and radeon driver.
Message-ID: <20110527155507.GB11273@dumpdata.com>
References: <6ac3f6faad655602b767aa14b355e982@admin.gogi.tv>
 <20110523220536.GB11961@dumpdata.com>
 <756073831c36e0404199a4e8239bcb70@admin.gogi.tv>
 <m2wrhf4sw5.fsf@firstfloor.org>
 <08370791664f069624d25c757ed101c0@admin.gogi.tv>
 <20110525125752.GB3467@dumpdata.com>
 <dfd8bfd19ba1fb77d6448bff97123e13@admin.gogi.tv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dfd8bfd19ba1fb77d6448bff97123e13@admin.gogi.tv>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090208.4DDFC965.008D:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 04:48:39PM +0100, Daniel Haid wrote:
> I have looked again at the radeon driver and it seems that the
> drm drivers use vmalloc_32 to allocate their dma memory and
> that vmalloc_32 should allocate physical 32-bit addresses
> (in 2.6.39)?

The DRM code is not used anymore. It was used by XFree86 but nowadays
the TTM code is used instead.

> 
> So why does it still not work?

Ah, this would be a lengthy writeup.. so did you look at the
link I pointed you to?
