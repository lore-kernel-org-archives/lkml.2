Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757012Ab1E0WUN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 18:20:13 -0400
Received: from hyde.gogi.tv ([87.106.161.174]:50077 "EHLO hyde.gogi.tv"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754478Ab1E0WUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 18:20:11 -0400
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Fri, 27 May 2011 23:20:09 +0100
From: Daniel Haid <d.haid@gogi.tv>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Andi Kleen <andi@firstfloor.org>, <linux-kernel@vger.kernel.org>
Subject: Re: Question about iommu on =?UTF-8?Q?x=38=36=5F=36=34=20and=20ra?=
 =?UTF-8?Q?deon=20driver=2E?=
In-Reply-To: <20110527155507.GB11273@dumpdata.com>
References: <6ac3f6faad655602b767aa14b355e982@admin.gogi.tv>
 <20110523220536.GB11961@dumpdata.com>
 <756073831c36e0404199a4e8239bcb70@admin.gogi.tv>
 <m2wrhf4sw5.fsf@firstfloor.org>
 <08370791664f069624d25c757ed101c0@admin.gogi.tv>
 <20110525125752.GB3467@dumpdata.com>
 <dfd8bfd19ba1fb77d6448bff97123e13@admin.gogi.tv>
 <20110527155507.GB11273@dumpdata.com>
Message-ID: <9e26ea71798d10a3f900c777b71ff485@admin.gogi.tv>
User-Agent: Roundcube Webmail/0.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The DRM code is not used anymore. It was used by XFree86 but nowadays
> the TTM code is used instead.

 I see

> Ah, this would be a lengthy writeup.. so did you look at the
> link I pointed you to?

 Yes I have started, but do not understand everything yet.

 What are MFNs? Is this something Xen-specific?

 An does your post imply that on bare metal with "swiotlb=force 
 iommu=soft"
 alloc_page with GFP_DMA32 does also not allocate under 4GB?

