Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759563Ab0HEAVV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 20:21:21 -0400
Received: from sh.osrg.net ([192.16.179.4]:55092 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759522Ab0HEAVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 20:21:18 -0400
Date: Thu, 5 Aug 2010 09:16:26 +0900
To: peter.crosthwaite@petalogix.com
Cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org,
        penberg@cs.helsinki.fi, mpm@selenic.com, michal.simek@petalogix.com,
        edgar.iglesias@petalogix.com, john.williams@petalogix.com
Subject: Re: Using Bootmem for large DMA buffers in the presence of the
 slab 	allocator
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <AANLkTimK4NhXasetA4ZeeCeGSGySRNm8n=UgT+1oY_2g@mail.gmail.com>
References: <AANLkTimK4NhXasetA4ZeeCeGSGySRNm8n=UgT+1oY_2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100805091523U.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 05 Aug 2010 09:16:28 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Aug 2010 16:07:52 +1000
Peter Crosthwaite <peter.crosthwaite@petalogix.com> wrote:

> I am currently developing Kernel code to allocate and reserve a large
> (64MB) contiguous buffer for DMA.

A buffer needs to be physically continuous (your hardware can't do
scatter gather)? If so, as already pointed out, there is no pretty
solution for it.

There are some drivers that need to do such so the issue has been
under discussion:

http://marc.info/?l=linux-mm&m=128015343705933&w=2
