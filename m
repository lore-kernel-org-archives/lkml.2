Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861Ab1FANZE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 09:25:04 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:37137 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab1FANZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 09:25:02 -0400
Date: Wed, 1 Jun 2011 09:24:44 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Daniel Haid <d.haid@gogi.tv>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Question about iommu on x86_64 and radeon driver.
Message-ID: <20110601132444.GA4081@dumpdata.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d0ce6a4ba6092a1a9ef0f1e8f3cac9c9@admin.gogi.tv>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4DE63DA6.01A5:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 08:57:39PM +0100, Daniel Haid wrote:
> Just another question, the problem seems to be an issue with
> 
> swiotlb=force
> 
> and I assume that without "force" DMA with addresses that
> already are below 4GB should be handled without any
> bounce-buffer, and with "force" everything goes through
> the bounce-buffer, is this correct?
> 
> Now I have a VIA chipset where the IOMMU does not work, so
> swiotlb is activated, but is it activated in force mode or
> in normal mode? How can I find out?

Look in the source code. I somehow assumed it would activate it
but maybe it isn't. And the problem you have is related to
something else?
> 
> If it is activated in force mode, maybe the problem will
> go away in normal mode?

<nods> Should.
