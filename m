Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666Ab2DDJYh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 05:24:37 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:43744 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447Ab2DDJYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 05:24:35 -0400
Date: Wed, 04 Apr 2012 05:24:23 -0400 (EDT)
Message-Id: <20120404.052423.998527504342669775.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: slash@ac.auone-net.jp, netdev@vger.kernel.org, xemul@parallels.com,
        linux-kernel@vger.kernel.org
Subject: Re: Commit 8ef874bfc7296fa206eea2ad1e8a426f576bf6f6 has broken ss
 command
From: David Miller <davem@davemloft.net>
In-Reply-To: <1333530463.18626.545.camel@edumazet-glaptop>
References: <20120404090312.1B68C6AC03E@msa102.auone-net.jp>
	<1333530463.18626.545.camel@edumazet-glaptop>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 04 Apr 2012 02:24:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Wed, 04 Apr 2012 11:07:43 +0200

> On Wed, 2012-04-04 at 18:03 +0900, Kusanagi Kouichi wrote:
>> Since commit 8ef874bfc7296fa206eea2ad1e8a426f576bf6f6 ("sock_diag:
>> Move the sock_ code to net/core/"), ss command from iproute package
>> doesn't work if INET_DIAG is not enabled.
>> 
>> $ ss
>> State       Recv-Q Send-Q                                             Local Address:Port                                                 Peer Address:Port
>> TCPDIAG answers: Operation not supported
>> --
> 
> Try to update your iproute2 package ?

Well, he doesn't INET_DIAG enabled in his kernel, so no matter what
iproute2 version he uses it won't work :-)
