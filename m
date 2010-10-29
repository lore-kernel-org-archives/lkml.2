Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932407Ab0J2Ukh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 16:40:37 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46255
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761845Ab0J2Ukf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 16:40:35 -0400
Date: Fri, 29 Oct 2010 13:40:58 -0700 (PDT)
Message-Id: <20101029.134058.246543591.davem@davemloft.net>
To: jj@chaosbits.net
Cc: eric.dumazet@gmail.com, alban.crequy@collabora.co.uk,
        shemminger@vyatta.com, gorcunov@openvz.org, adobriyan@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        pauli.nieminen@collabora.co.uk, rweikusat@mssgmbh.com
Subject: Re: [PATCH 0/1] RFC: poll/select performance on datagram sockets
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LNX.2.00.1010292217390.24561@swampdragon.chaosbits.net>
References: <20101029191857.5f789d56@chocolatine.cbg.collabora.co.uk>
	<1288380431.2680.3.camel@edumazet-laptop>
	<alpine.LNX.2.00.1010292217390.24561@swampdragon.chaosbits.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Juhl <jj@chaosbits.net>
Date: Fri, 29 Oct 2010 22:20:12 +0200 (CEST)

> Sorry to intrude out of the blue without really understanding the kernel 
> side of most of the code in question, but if there's a performance 
> regression for applications using poll() shouldn't we address that so we 
> get back to the prior performance level rather than requireing all 
> userspace apps to switch to epoll() ??

For such a pathological program like Alban's test case, I say
absolutely not.
