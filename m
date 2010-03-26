Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275Ab0CZDdV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 23:33:21 -0400
Received: from sh.osrg.net ([192.16.179.4]:46836 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753914Ab0CZDdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 23:33:19 -0400
Date: Fri, 26 Mar 2010 12:33:12 +0900
To: hancockrwd@gmail.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-usb@vger.kernel.org, davem@davemloft.net,
       bzolnier@gmail.com
Subject: Re: [PATCH RFC] fix problems with NETIF_F_HIGHDMA in networking 
	drivers v2
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <51f3faa71003251803q7ccec5d5x82bc277c590e2848@mail.gmail.com>
References: <4B8F213B.40603@gmail.com>
	<20100304135738C.fujita.tomonori@lab.ntt.co.jp>
	<51f3faa71003251803q7ccec5d5x82bc277c590e2848@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100326123250A.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 26 Mar 2010 12:33:12 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Mar 2010 19:03:37 -0600
Robert Hancock <hancockrwd@gmail.com> wrote:

> This seems like it could be a reasonable approach. The only thing is
> that in this code you're returning 1 if the parent device has no DMA
> mask set. Wouldn't it make more sense to return 0 in this case? I'm
> assuming that in that situation it's a virtual device not backed by
> any hardware and there should be no DMA mask restriction...

I chose the safer option because I don't know enough how net_device
structure is used. If returning zero in such case is always safe, it's
fine by me. any example of such virtual device driver?
