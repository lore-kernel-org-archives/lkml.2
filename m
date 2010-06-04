Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757007Ab0FDBOf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 21:14:35 -0400
Received: from sh.osrg.net ([192.16.179.4]:38147 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753403Ab0FDBOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 21:14:34 -0400
Date: Fri, 4 Jun 2010 10:14:27 +0900
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: mmotm 2010-06-03-16-36 uploaded
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <201006040005.o5405Afw023296@imap1.linux-foundation.org>
References: <201006040005.o5405Afw023296@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100604101329D.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 04 Jun 2010 10:14:27 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Jun 2010 16:36:51 -0700
akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2010-06-03-16-36 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> and will soon be available at
> 
>    git://zen-kernel.org/kernel/mmotm.git
> 
> It contains the following patches against 2.6.35-rc1:

(snip)

> ssb-add-dma_dev-to-ssb_device-structure.patch
> b43legacy-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
> b43-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
> b44-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
> ssb-remove-the-ssb-dma-api.patch

Is there any reason why the above patches are still in -mm (i.e. not
merged in the previous merge window)?

I got an ACK on the first patch to ssb core from the ssb maintainer,
ACKs on the second and third to b43legacy and b43 from the maintainer.

http://marc.info/?t=126621151900002&r=1&w=2


Thanks,
