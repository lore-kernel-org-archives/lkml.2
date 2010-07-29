Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560Ab0G2Np0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 09:45:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34836 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754113Ab0G2NpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 09:45:25 -0400
Message-ID: <4C5185D0.9060507@zytor.com>
Date: Thu, 29 Jul 2010 06:44:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: konrad.wilk@oracle.com, jeremy@goop.org, Ian.Campbell@citrix.com,
        albert_herranz@yahoo.es, x86@kernel.org, jbarnes@virtuousgeek.org,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        tglx@linutronix.de
Subject: Re: [PATCH 9/9] x86: Detect whether we should use Xen SWIOTLB.
References: <20100728095157I.fujita.tomonori@lab.ntt.co.jp>	<20100728223816.GB32739@phenom.dumpdata.com>	<4C50B4C2.2070807@zytor.com> <20100729161653G.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100729161653G.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2010 12:17 AM, FUJITA Tomonori wrote:
> btw, (c) is not the fallback case (i.e. if we can't find hardware
> IOMMU, we enable swiotlb). We use both hardware IOMMU and swiotlb on
> some systems.

Right, which is why it can't be folded into (b).

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

