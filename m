Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684Ab0G1Wxl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 18:53:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42260 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752071Ab0G1Wxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 18:53:39 -0400
Message-ID: <4C50B4C2.2070807@zytor.com>
Date: Wed, 28 Jul 2010 15:52:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, jeremy@goop.org,
        Ian.Campbell@citrix.com, albert_herranz@yahoo.es, x86@kernel.org,
        jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, tglx@linutronix.de
Subject: Re: [PATCH 9/9] x86: Detect whether we should use Xen SWIOTLB.
References: <20100727194105.GA18647@phenom.dumpdata.com> <20100728083526J.fujita.tomonori@lab.ntt.co.jp> <4C4F779D.9060908@zytor.com> <20100728095157I.fujita.tomonori@lab.ntt.co.jp> <20100728223816.GB32739@phenom.dumpdata.com>
In-Reply-To: <20100728223816.GB32739@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/2010 03:38 PM, Konrad Rzeszutek Wilk wrote:
> 
> Long term I think the driverization is the way to go, and..
> 
> I think the flow a). check if we need SWIOTLB b), check all IOMMUs, c).
> recheck SWIOTLB in case no IOMMUs volunteered MUST be preserved
> irregardless if we driverize the IOMMUs/SWIOTLB or not.
> 
> Perhaps we should get together at one of these Linux conferences and
> think this one through? Beers on me.
> 

I don't understand point (a) here.  (c) simply seems like the fallback
case, and in the case we are actively forcing swiotlb we simply skip
step (b).

	-hpa
