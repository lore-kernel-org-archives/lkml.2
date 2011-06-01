Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758322Ab1FAQKr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 12:10:47 -0400
Received: from hyde.gogi.tv ([87.106.161.174]:54166 "EHLO hyde.gogi.tv"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757076Ab1FAQKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 12:10:46 -0400
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Wed, 01 Jun 2011 17:10:44 +0100
From: Daniel Haid <d.haid@gogi.tv>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>
Subject: Re: Question about iommu on =?UTF-8?Q?x=38=36=5F=36=34=20and=20ra?=
 =?UTF-8?Q?deon=20driver=2E?=
In-Reply-To: <20110601132444.GA4081@dumpdata.com>
References: <20110525125752.GB3467@dumpdata.com>
 <dfd8bfd19ba1fb77d6448bff97123e13@admin.gogi.tv>
 <20110527155507.GB11273@dumpdata.com>
 <9e26ea71798d10a3f900c777b71ff485@admin.gogi.tv>
 <20110531134519.GC14641@dumpdata.com>
 <59be1730ec1660abeb7b4dc584510d34@admin.gogi.tv>
 <20110531160221.GA31659@dumpdata.com>
 <0a8cb4bcad7fcf091a6bbe158323bba0@admin.gogi.tv>
 <20110531190412.GA21245@dumpdata.com>
 <d0ce6a4ba6092a1a9ef0f1e8f3cac9c9@admin.gogi.tv>
 <20110601132444.GA4081@dumpdata.com>
Message-ID: <21491fcfb013e21177140326efc0ee66@admin.gogi.tv>
User-Agent: Roundcube Webmail/0.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Look in the source code. I somehow assumed it would activate it
> but maybe it isn't. And the problem you have is related to
> something else?

 If I have read the code correctly the only way to get
 swiotlb_force=1 in lib/swiotlb.c is to add the "swiotlb=force"
 argument to the kernel parameters.

 Without it on VIA chipsets swiotlb gets activated, but with
 swiotlb_force=0. In this case DMA to addresses below 4GB should be
 direct.

 But since I still get the error the radeon driver must (incorrectly)
 allocate memory above 4GB somewhere, but where?


