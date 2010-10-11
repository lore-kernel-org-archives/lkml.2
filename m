Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074Ab0JKTrF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 15:47:05 -0400
Received: from sh.osrg.net ([192.16.179.4]:39572 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755963Ab0JKTrE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 15:47:04 -0400
Date: Tue, 12 Oct 2010 04:41:55 +0900
To: konrad.wilk@oracle.com
Cc: yinghai@kernel.org, fujita.tomonori@lab.ntt.co.jp,
        akpm@linux-foundation.org, mingo@elte.hu, andre.goddard@gmail.com,
        linux-kernel@vger.kernel.org, beckyb@kernel.crashing.org
Subject: Re: [PATCH] swiotlb: Use page alignment for early buffer allocation
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20101011185552.GA29540@dumpdata.com>
References: <4CB34C09.2060100@kernel.org>
	<20101011185552.GA29540@dumpdata.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20101012043704B.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 12 Oct 2010 04:41:57 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Oct 2010 14:55:52 -0400
Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:

> On Mon, Oct 11, 2010 at 10:40:25AM -0700, Yinghai Lu wrote:
> > 
> > We could call free_bootmem_late() if swiotlb is not used, and
> > it will shrink to page alignment.
> > 
> > So alloc them with page alignment at first, to avoid lose two pages
> 
> Looks good to me.

Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

I'm not a big fun of using PAGE_ALING for size (not address) though.

> Fujita, you OK if I queue this up along with your other patch
> (swiotlb: make io_tlb_overflow static)

Fine by me.

Thanks,
