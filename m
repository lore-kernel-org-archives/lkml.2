Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825Ab0HBQxl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 12:53:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54598 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355Ab0HBQxk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 12:53:40 -0400
Message-ID: <4C56F7FE.2030700@zytor.com>
Date: Mon, 02 Aug 2010 09:53:18 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, jeremy@goop.org,
        Ian.Campbell@citrix.com, albert_herranz@yahoo.es, x86@kernel.org,
        linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
        iommu@lists.linux-foundation.org, tglx@linutronix.de
Subject: Re: [PATCH 9/9] x86: Detect whether we should use Xen SWIOTLB.
References: <4C56E49E.6070102@zytor.com> <20100803004252B.fujita.tomonori@lab.ntt.co.jp> <4C56E8A9.1060004@zytor.com> <20100803010025R.fujita.tomonori@lab.ntt.co.jp> <20100802164234.GC6961@phenom.dumpdata.com>
In-Reply-To: <20100802164234.GC6961@phenom.dumpdata.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2010 09:42 AM, Konrad Rzeszutek Wilk wrote:
> 
> Let me go to my favorite coffee shop and think this one through.
> Can I get concession for putting the original patch in (the simple, dumb one),
> and then:
>  - start working on the IOMMU register interface without having to try
>    to get it done for 2.6.36, and
>  - do the driverization as a seperate cleanup.
> 

That makes sense.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

