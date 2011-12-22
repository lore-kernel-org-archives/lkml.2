Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908Ab1LVHF3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 02:05:29 -0500
Received: from a.mx.secunet.com ([195.81.216.161]:57762 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733Ab1LVHF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 02:05:26 -0500
Date: Thu, 22 Dec 2011 08:05:18 +0100
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Chris Boot <bootc@bootc.net>, David Miller <davem@davemloft.net>,
        lkml <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] bridge: provide a mtu() method for fake_dst_ops
Message-ID: <20111222070518.GQ6348@secunet.com>
References: <4EF2117F.6000803@bootc.net>
 <1324488984.2301.45.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <1324490401.2301.46.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <4EF23BF2.4000601@bootc.net>
 <1324499332.2621.7.camel@edumazet-laptop>
 <1324500775.2621.9.camel@edumazet-laptop>
 <4EF2568C.6040006@bootc.net>
 <AEC29013-98F3-4A16-A88B-AD31C9E88EB8@bootc.net>
 <1324528656.2621.19.camel@edumazet-laptop>
 <1324533632.2621.35.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324533632.2621.35.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 22 Dec 2011 07:05:18.0849 (UTC) FILETIME=[10455710:01CCC078]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 07:00:32AM +0100, Eric Dumazet wrote:
> Commit 618f9bc74a039da76 (net: Move mtu handling down to the protocol
> depended handlers) forgot the bridge netfilter case, adding a NULL
> dereference in ip_fragment().
> 
> Reported-by: Chris Boot <bootc@bootc.net>
> CC: Steffen Klassert <steffen.klassert@secunet.com>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

As I said in the other mail, the bug is probaply arround
for longer. Anyway,

Acked-by: Steffen Klassert <steffen.klassert@secunet.com>

Thanks!
