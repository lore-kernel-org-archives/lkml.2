Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743Ab2LKSkR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 13:40:17 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:36097 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752948Ab2LKSkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 13:40:15 -0500
Date: Tue, 11 Dec 2012 13:39:37 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Lin Feng <linfeng@cn.fujitsu.com>
Cc: akpm@linux-foundation.org, yinghai@kernel.org, hpa@zytor.com,
        davem@davemloft.net, eric.dumazet@gmail.com, tj@kernel.org,
        shangw@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm/bootmem.c: remove unused wrapper function
 reserve_bootmem_generic()
Message-ID: <20121211183937.GA5168@cmpxchg.org>
References: <1355213523-15698-1-git-send-email-linfeng@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355213523-15698-1-git-send-email-linfeng@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 04:12:03PM +0800, Lin Feng wrote:
> Wrapper fucntion reserve_bootmem_generic() currently have no caller,
> so clean it up.
> 
> Signed-off-by: Lin Feng <linfeng@cn.fujitsu.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
