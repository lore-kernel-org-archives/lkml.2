Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932326Ab1EYKAh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 06:00:37 -0400
Received: from hyde.gogi.tv ([87.106.161.174]:57192 "EHLO hyde.gogi.tv"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397Ab1EYKAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 06:00:36 -0400
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Wed, 25 May 2011 11:00:33 +0100
From: Daniel Haid <d.haid@gogi.tv>
To: Andi Kleen <andi@firstfloor.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: Question about iommu on =?UTF-8?Q?x=38=36=5F=36=34=20and=20ra?=
 =?UTF-8?Q?deon=20driver=2E?=
In-Reply-To: <m2wrhf4sw5.fsf@firstfloor.org>
References: <6ac3f6faad655602b767aa14b355e982@admin.gogi.tv>
 <20110523220536.GB11961@dumpdata.com>
 <756073831c36e0404199a4e8239bcb70@admin.gogi.tv>
 <m2wrhf4sw5.fsf@firstfloor.org>
Message-ID: <08370791664f069624d25c757ed101c0@admin.gogi.tv>
User-Agent: Roundcube Webmail/0.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I added it originally. The VIA chipset seems to hang on most
> DMAs through the IOMMU, so it was disabled.

 I see. Now, maybe this will not work for some reason, but
 would it be possible to somehow disable both IOMMU and SWIOTLB
 and tell all drivers only to do DMA with the lower 4GB of memory?

 Unfortunately simply turning "iommu=off" does not work for me
 as the sata and pata drivers stop working.
