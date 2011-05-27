Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553Ab1E0Pso (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 11:48:44 -0400
Received: from hyde.gogi.tv ([87.106.161.174]:48087 "EHLO hyde.gogi.tv"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316Ab1E0Psl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 11:48:41 -0400
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Fri, 27 May 2011 16:48:39 +0100
From: Daniel Haid <d.haid@gogi.tv>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andi Kleen <andi@firstfloor.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: Question about iommu on =?UTF-8?Q?x=38=36=5F=36=34=20and=20ra?=
 =?UTF-8?Q?deon=20driver=2E?=
In-Reply-To: <20110525125752.GB3467@dumpdata.com>
References: <6ac3f6faad655602b767aa14b355e982@admin.gogi.tv>
 <20110523220536.GB11961@dumpdata.com>
 <756073831c36e0404199a4e8239bcb70@admin.gogi.tv>
 <m2wrhf4sw5.fsf@firstfloor.org>
 <08370791664f069624d25c757ed101c0@admin.gogi.tv>
 <20110525125752.GB3467@dumpdata.com>
Message-ID: <dfd8bfd19ba1fb77d6448bff97123e13@admin.gogi.tv>
User-Agent: Roundcube Webmail/0.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 I have looked again at the radeon driver and it seems that the
 drm drivers use vmalloc_32 to allocate their dma memory and
 that vmalloc_32 should allocate physical 32-bit addresses
 (in 2.6.39)?

 So why does it still not work?


