Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933191Ab2BAWoF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 17:44:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52921 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756313Ab2BAWoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 17:44:03 -0500
Date: Wed, 1 Feb 2012 14:44:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: William Irwin <wli@holomorphy.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] mm: search from free_area_cache for the bigger size
Message-Id: <20120201144401.af84e3a2.akpm@linux-foundation.org>
In-Reply-To: <4F1019D3.8020709@linux.vnet.ibm.com>
References: <4F101904.8090405@linux.vnet.ibm.com>
	<4F1019D3.8020709@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jan 2012 19:47:31 +0800
Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:

> If the required size is bigger than cached_hole_size, we would better search
> from free_area_cache, it is more easier to get free region, specifically for
> the 64 bit process whose address space is large enough
> 
> Do it just as hugetlb_get_unmapped_area_topdown() in arch/x86/mm/hugetlbpage.c

Can this cause additional fragmentation of the virtual address region? 
If so, what might be the implications of this?

