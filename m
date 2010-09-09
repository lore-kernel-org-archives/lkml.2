Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229Ab0IIWCm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:02:42 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34391
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753455Ab0IIWCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:02:40 -0400
Date: Thu, 09 Sep 2010 15:02:58 -0700 (PDT)
Message-Id: <20100909.150258.260099563.davem@davemloft.net>
To: namhyung@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] net/core: remove address space warnings on
 verify_iovec()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1283953728-15302-1-git-send-email-namhyung@gmail.com>
References: <1283953728-15302-1-git-send-email-namhyung@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@gmail.com>
Date: Wed,  8 Sep 2010 22:48:47 +0900

> move_addr_to_kernel() and copy_from_user() requires their argument
> as __user pointer but were missing proper markups. Add it.
> This removes following warnings from sparse.
> 
>  net/core/iovec.c:44:52: warning: incorrect type in argument 1 (different address spaces)
>  net/core/iovec.c:44:52:    expected void [noderef] <asn:1>*uaddr
>  net/core/iovec.c:44:52:    got void *msg_name
>  net/core/iovec.c:55:34: warning: incorrect type in argument 2 (different address spaces)
>  net/core/iovec.c:55:34:    expected void const [noderef] <asn:1>*from
>  net/core/iovec.c:55:34:    got struct iovec *msg_iov
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>

Applied.
