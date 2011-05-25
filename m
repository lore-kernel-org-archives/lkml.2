Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932817Ab1EYOv3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 10:51:29 -0400
Received: from hyde.gogi.tv ([87.106.161.174]:56506 "EHLO hyde.gogi.tv"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753414Ab1EYOv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 10:51:28 -0400
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Wed, 25 May 2011 15:51:26 +0100
From: Daniel Haid <d.haid@gogi.tv>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
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
Message-ID: <6d6b404ccb4dc0a713e8e12403acde32@admin.gogi.tv>
User-Agent: Roundcube Webmail/0.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I see. Now, maybe this will not work for some reason, but
>> would it be possible to somehow disable both IOMMU and SWIOTLB
>> and tell all drivers only to do DMA with the lower 4GB of memory?
>
> Only if you allow 3GB or less in the machine. So you would have to do
> mem=3G as well.
>
> The reason is that (and you can see that yourself by looking at the
> E820), is that 1GB is actually _above_ the 4GB.

 I see. Is it possible to somehow give "mem=3G" to the kernel and still
 use the memory above 4G for something, like a ramdisk or something?
