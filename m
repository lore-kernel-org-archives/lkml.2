Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407Ab1EVOOU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 10:14:20 -0400
Received: from lo.gmane.org ([80.91.229.12]:39985 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754479Ab1EVOOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 10:14:14 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: WANG Cong <xiyou.wangcong@gmail.com>
Subject: Re: PA-RISC: compile error in include/net/dst.h
Date: Sun, 22 May 2011 14:13:58 +0000 (UTC)
Message-ID: <irb5n6$vn3$1@dough.gmane.org>
References: <2612811.b2htuyZy9x@donald.sf-tec.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 123.124.21.91
User-Agent: Pan/0.133 (House of Butterflies)
Cc: linux-parisc@vger.kernel.org, stable@linux.kernel.org,
        netdev@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Cc netdev as well)

On Sun, 22 May 2011 10:15:19 +0200, Rolf Eike Beer wrote:

> from include/net/ipv6.h:16,
>                  from include/linux/sunrpc/clnt.h:25,
>                  from include/linux/nfs_fs.h:50,
>                  from init/do_mounts.c:20:
> include/net/dst.h: In function 'dst_hold': include/net/dst.h:238:2:
> error: size of unnamed array is negative In file included from
> include/linux/nfs_fs.h:59:0,
>                  from init/do_mounts.c:20:


Seems someone touched struct dst_entry...

> include/linux/mempool.h: In function 'mempool_create_kmalloc_pool':
> include/linux/mempool.h:58:10: warning: cast to pointer from integer of
> different size
> 
> This is both in 2.6.38.6 and 2.6.39, but is not in 2.6.38.4 when
> compiling for my C8000.
> 
> pioneer src #  hppa64-unknown-linux-gnu-gcc --version
> hppa64-unknown-linux-gnu-gcc (Gentoo 4.5.2 p1.1) 4.5.2
> 
> Greetings,
> 
> Eike


