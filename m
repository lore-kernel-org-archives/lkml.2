Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201Ab1FPQYq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 12:24:46 -0400
Received: from sh.osrg.net ([192.16.179.4]:51644 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752698Ab1FPQYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 12:24:44 -0400
Date: Fri, 17 Jun 2011 01:23:58 +0900
To: xiyou.wangcong@gmail.com
Cc: fujita.tomonori@lab.ntt.co.jp, vinod.koul@intel.com,
        dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Subject: Re: [Patch] dma: remove DMA_xxBIT_MASK macros
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20110616090037.GA10326@cr0.redhat.com>
References: <20110616090037.GA10326@cr0.redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20110617011923Z.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 17 Jun 2011 01:23:59 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jun 2011 17:00:37 +0800
**UNKNOWN CHARSET** Wang <xiyou.wangcong@gmail.com> wrote:

> 
> git grep shows there are no users in tree, so we can
> remove them safely.
> 
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
> Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> 
> ---
>  Documentation/feature-removal-schedule.txt |    7 -------
>  include/linux/dma-mapping.h                |   21 ---------------------
>  2 files changed, 0 insertions(+), 28 deletions(-)

Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Andrew, can you merge this via the -mm tree?

Thanks,
