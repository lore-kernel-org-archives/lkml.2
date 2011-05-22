Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab1EVObn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 10:31:43 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:55566 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755133Ab1EVObg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 10:31:36 -0400
X-Sasl-enc: 3oLTXHhH0oCxrT61O3N+wAR+ohKrg8LUG1ikfjYkQDKF 1306074695
Date: Sun, 22 May 2011 07:32:22 -0700
From: Greg KH <greg@kroah.com>
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: Parisc List <linux-parisc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, stable@kernel.org
Subject: Re: [stable] PA-RISC: compile error in include/net/dst.h
Message-ID: <20110522143222.GB14556@kroah.com>
References: <2612811.b2htuyZy9x@donald.sf-tec.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2612811.b2htuyZy9x@donald.sf-tec.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 22, 2011 at 10:15:19AM +0200, Rolf Eike Beer wrote:
>                  from include/net/ipv6.h:16,
>                  from include/linux/sunrpc/clnt.h:25,
>                  from include/linux/nfs_fs.h:50,
>                  from init/do_mounts.c:20:
> include/net/dst.h: In function 'dst_hold':
> include/net/dst.h:238:2: error: size of unnamed array is negative
> In file included from include/linux/nfs_fs.h:59:0,
>                  from init/do_mounts.c:20:
> include/linux/mempool.h: In function 'mempool_create_kmalloc_pool':
> include/linux/mempool.h:58:10: warning: cast to pointer from integer of 
> different size
> 
> This is both in 2.6.38.6 and 2.6.39, but is not in 2.6.38.4 when compiling for 
> my C8000.

Could you bisect it down to the patch that causes the problem in
2.6.38.6?

thanks,

greg k-h
