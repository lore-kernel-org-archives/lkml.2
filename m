Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623Ab0FGF0M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 01:26:12 -0400
Received: from sh.osrg.net ([192.16.179.4]:35227 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751983Ab0FGF0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 01:26:09 -0400
Date: Mon, 7 Jun 2010 14:25:56 +0900
To: fujita.tomonori@lab.ntt.co.jp
Cc: cmetcalf@tilera.com, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, torvalds@linux-foundation.org,
       lethal@linux-sh.org
Subject: Re: [PATCH] arch/tile: respond to reviews of the second code
 submission.
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100604103049M.fujita.tomonori@lab.ntt.co.jp>
References: <201005290334.o4T3Y1FX029944@farm-0002.internal.tilera.com>
	<201006032141.o53LfZC9019335@lab-15.internal.tilera.com>
	<20100604103049M.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100607142446D.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 07 Jun 2010 14:25:57 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Jun 2010 10:31:17 +0900
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> On Thu, 3 Jun 2010 17:32:17 -0400
> Chris Metcalf <cmetcalf@tilera.com> wrote:
> 
> > This change addresses DMA-related comments by FUJITA Tomonori
> 
> What about the comment on dma_alloc_coherent()?

I saw that you addressed two issues (coherent_mask and GFP_KERNEL
usage) in linux-next. Both changes look fine to me.
