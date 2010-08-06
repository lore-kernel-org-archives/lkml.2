Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935034Ab0HFACq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 20:02:46 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65524 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935123Ab0HFACi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 20:02:38 -0400
MIME-Version: 1.0
In-Reply-To: <20100805091523U.fujita.tomonori@lab.ntt.co.jp>
References: <AANLkTimK4NhXasetA4ZeeCeGSGySRNm8n=UgT+1oY_2g@mail.gmail.com>
	<20100805091523U.fujita.tomonori@lab.ntt.co.jp>
Date: Fri, 6 Aug 2010 10:02:36 +1000
Message-ID: <AANLkTi=gAdLEaPfo==AMerh_kE2-+Va2oir-jHrNRu4u@mail.gmail.com>
Subject: Re: Using Bootmem for large DMA buffers in the presence of the slab 
	allocator
From: Peter Crosthwaite <peter.crosthwaite@petalogix.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org,
        penberg@cs.helsinki.fi, mpm@selenic.com, michal.simek@petalogix.com,
        edgar.iglesias@petalogix.com, john.williams@petalogix.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Everyone,

Thanks for your replies. I am going to stick with my start_kernel()
edit until this CMA engine comes along.

Regards,
Peter

On Thu, Aug 5, 2010 at 10:16 AM, FUJITA Tomonori
<fujita.tomonori@lab.ntt.co.jp> wrote:
> On Wed, 4 Aug 2010 16:07:52 +1000
> Peter Crosthwaite <peter.crosthwaite@petalogix.com> wrote:
>
>> I am currently developing Kernel code to allocate and reserve a large
>> (64MB) contiguous buffer for DMA.
>
> A buffer needs to be physically continuous (your hardware can't do
> scatter gather)? If so, as already pointed out, there is no pretty
> solution for it.
>
> There are some drivers that need to do such so the issue has been
> under discussion:
>
> http://marc.info/?l=linux-mm&m=128015343705933&w=2
>
