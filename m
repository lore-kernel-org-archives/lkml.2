Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758290Ab1EaT5m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 15:57:42 -0400
Received: from hyde.gogi.tv ([87.106.161.174]:60563 "EHLO hyde.gogi.tv"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757862Ab1EaT5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 15:57:41 -0400
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Tue, 31 May 2011 20:57:39 +0100
From: Daniel Haid <d.haid@gogi.tv>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: Question about iommu on =?UTF-8?Q?x=38=36=5F=36=34=20and=20ra?=
 =?UTF-8?Q?deon=20driver=2E?=
In-Reply-To: <20110531190412.GA21245@dumpdata.com>
References: <m2wrhf4sw5.fsf@firstfloor.org>
 <08370791664f069624d25c757ed101c0@admin.gogi.tv>
 <20110525125752.GB3467@dumpdata.com>
 <dfd8bfd19ba1fb77d6448bff97123e13@admin.gogi.tv>
 <20110527155507.GB11273@dumpdata.com>
 <9e26ea71798d10a3f900c777b71ff485@admin.gogi.tv>
 <20110531134519.GC14641@dumpdata.com>
 <59be1730ec1660abeb7b4dc584510d34@admin.gogi.tv>
 <20110531160221.GA31659@dumpdata.com>
 <0a8cb4bcad7fcf091a6bbe158323bba0@admin.gogi.tv>
 <20110531190412.GA21245@dumpdata.com>
Message-ID: <d0ce6a4ba6092a1a9ef0f1e8f3cac9c9@admin.gogi.tv>
User-Agent: Roundcube Webmail/0.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Just another question, the problem seems to be an issue with

 swiotlb=force

 and I assume that without "force" DMA with addresses that
 already are below 4GB should be handled without any
 bounce-buffer, and with "force" everything goes through
 the bounce-buffer, is this correct?

 Now I have a VIA chipset where the IOMMU does not work, so
 swiotlb is activated, but is it activated in force mode or
 in normal mode? How can I find out?

 If it is activated in force mode, maybe the problem will
 go away in normal mode?

