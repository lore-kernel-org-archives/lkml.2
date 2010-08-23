Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158Ab0HWDbZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 23:31:25 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37087
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752899Ab0HWDbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 23:31:23 -0400
Date: Sun, 22 Aug 2010 20:31:40 -0700 (PDT)
Message-Id: <20100822.203140.15257163.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, baronchon@n7mm.org
Subject: Re: linux-next: build failure after merge of the final tree (net
 tree related)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100823132734.ffc076ae.sfr@canb.auug.org.au>
References: <20100823132734.ffc076ae.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 23 Aug 2010 13:27:34 +1000

> Subject: [PATCH] net/sched: need to include net/ip6_checksum.h
> 
> for the declararion of csum_ipv6_magic.
> 
> Fixes this build error on PowerPC (at least):
> 
> net/sched/act_csum.c: In function 'tcf_csum_ipv6_icmp':
> net/sched/act_csum.c:178: error: implicit declaration of function 'csum_ipv6_magic'
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Oh, if I only had a dollar for every time we've had to fix up
something like this :-)

Applied, thanks!
