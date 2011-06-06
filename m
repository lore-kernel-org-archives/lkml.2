Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757770Ab1FFUGq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 16:06:46 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:31723 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757237Ab1FFUGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 16:06:43 -0400
Date: Mon, 6 Jun 2011 13:06:28 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for June 6 (frontswap)
Message-Id: <20110606130628.e0110e18.randy.dunlap@oracle.com>
In-Reply-To: <20110606132036.aebd73a4.sfr@canb.auug.org.au>
References: <20110606132036.aebd73a4.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090207.4DED334E.0163:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Jun 2011 13:20:36 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20110603:


Does frontswap need to depend on SWAP?

When SWAP is not enabled:

mm/built-in.o: In function `frontswap_curr_pages':
(.text+0x467c1): undefined reference to `swap_lock'
mm/built-in.o: In function `frontswap_curr_pages':
(.text+0x467ce): undefined reference to `swap_list'
mm/built-in.o: In function `frontswap_curr_pages':
(.text+0x467e6): undefined reference to `swap_info'
mm/built-in.o: In function `frontswap_curr_pages':
(.text+0x467fe): undefined reference to `swap_lock'
mm/built-in.o: In function `frontswap_shrink':
(.text+0x4688d): undefined reference to `swap_lock'
mm/built-in.o: In function `frontswap_shrink':
(.text+0x46898): undefined reference to `swap_list'
mm/built-in.o: In function `frontswap_shrink':
(.text+0x468b6): undefined reference to `swap_info'
mm/built-in.o: In function `frontswap_shrink':
(.text+0x4690d): undefined reference to `swap_info'
mm/built-in.o: In function `frontswap_shrink':
(.text+0x469d3): undefined reference to `swap_lock'
mm/built-in.o: In function `frontswap_shrink':
(.text+0x469ec): undefined reference to `try_to_unuse'
mm/built-in.o: In function `frontswap_shrink':
(.text+0x46a1c): undefined reference to `swap_lock'
mm/built-in.o: In function `__frontswap_flush_area':
(.text+0x46aa4): undefined reference to `swap_info'
mm/built-in.o: In function `__frontswap_get_page':
(.text+0x46b1f): undefined reference to `swap_info'
mm/built-in.o: In function `__frontswap_put_page':
(.text+0x46bf8): undefined reference to `swap_info'
mm/built-in.o: In function `__frontswap_flush_page':
(.text+0x46d86): undefined reference to `swap_info'
mm/built-in.o: In function `frontswap_curr_pages':
(.text+0x467c1): undefined reference to `swap_lock'
mm/built-in.o: In function `frontswap_curr_pages':
(.text+0x467ce): undefined reference to `swap_list'
mm/built-in.o: In function `frontswap_curr_pages':
(.text+0x467e6): undefined reference to `swap_info'
mm/built-in.o: In function `frontswap_curr_pages':
(.text+0x467fe): undefined reference to `swap_lock'
mm/built-in.o: In function `frontswap_shrink':
(.text+0x4688d): undefined reference to `swap_lock'
mm/built-in.o: In function `frontswap_shrink':
(.text+0x46898): undefined reference to `swap_list'
mm/built-in.o: In function `frontswap_shrink':
(.text+0x468b6): undefined reference to `swap_info'
mm/built-in.o: In function `frontswap_shrink':
(.text+0x4690d): undefined reference to `swap_info'
mm/built-in.o: In function `frontswap_shrink':
(.text+0x469d3): undefined reference to `swap_lock'
mm/built-in.o: In function `frontswap_shrink':
(.text+0x469ec): undefined reference to `try_to_unuse'
mm/built-in.o: In function `frontswap_shrink':
(.text+0x46a1c): undefined reference to `swap_lock'
mm/built-in.o: In function `__frontswap_flush_area':
(.text+0x46aa4): undefined reference to `swap_info'
mm/built-in.o: In function `__frontswap_get_page':
(.text+0x46b1f): undefined reference to `swap_info'
mm/built-in.o: In function `__frontswap_put_page':
(.text+0x46bf8): undefined reference to `swap_info'
mm/built-in.o: In function `__frontswap_flush_page':
(.text+0x46d86): undefined reference to `swap_info'

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
