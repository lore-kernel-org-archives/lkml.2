Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab1CYR1d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 13:27:33 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:45290 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511Ab1CYR1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 13:27:31 -0400
Date: Fri, 25 Mar 2011 18:27:09 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: naveen yadav <yad.naveen@gmail.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: Re: flush_kernel_vmap_range() invalidate_kernel_vmap_range() API not
 exists for MIPS
Message-ID: <20110325172709.GC8483@linux-mips.org>
References: <AANLkTimkh2QLvupu+62NGrKfqRb_gC7KLCAKkEoS9N9N@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimkh2QLvupu+62NGrKfqRb_gC7KLCAKkEoS9N9N@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 02:38:13PM +0530, naveen yadav wrote:

> We are working on 2.6.35.9 linux kernel on MIPS 34kce core and our
> cache is VIVT having cache aliasing .

No, they're VIPT unless you successfully modified your 34K core to
change it from a less than perfect cache design to the most lunatic
cache policy known to man kind ...

> When I check the implementation on ARM I can check the implemenation
> exists , but there is not similar implementation exists on MIPS.
> These API's are used by XFS module:
> 
> static inline void flush_kernel_vmap_range(void *vaddr, int size)
> static inline void invalidate_kernel_vmap_range(void *vaddr, int size)
> static inline void flush_kernel_dcache_page(struct page *page)

A known problem for (too ...) long.  I'll finally take care of it.

  Ralf
