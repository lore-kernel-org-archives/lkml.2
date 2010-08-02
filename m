Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486Ab0HBPsk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 11:48:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37703 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502Ab0HBPsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 11:48:39 -0400
Message-ID: <4C56E8A9.1060004@zytor.com>
Date: Mon, 02 Aug 2010 08:47:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: konrad.wilk@oracle.com, jeremy@goop.org, Ian.Campbell@citrix.com,
        albert_herranz@yahoo.es, x86@kernel.org, linux-kernel@vger.kernel.org,
        jbarnes@virtuousgeek.org, iommu@lists.linux-foundation.org,
        tglx@linutronix.de
Subject: Re: [PATCH 9/9] x86: Detect whether we should use Xen SWIOTLB.
References: <20100729160557.GA4403@phenom.dumpdata.com>	<20100802152552.GA4732@phenom.dumpdata.com>	<4C56E49E.6070102@zytor.com> <20100803004252B.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100803004252B.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2010 08:43 AM, FUJITA Tomonori wrote:
> 
> That's the difficult part because IOMMUs are not
> interdependent. Hardware IOMMUs are related with swiotlb. GART and
> AMD-IOMMU are too.
> 
> We could invent sorta IOMMU register interface and driver-ize IOMMUs
> but they can't be interdependent completely.

Of course.  However, we need there to be as much structure to it as
there can be.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

