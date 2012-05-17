Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052Ab2EQTxT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 15:53:19 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:34368 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971Ab2EQTxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 15:53:18 -0400
Date: Thu, 17 May 2012 15:50:22 -0400 (EDT)
Message-Id: <20120517.155022.919927868768770215.davem@davemloft.net>
To: eldad@fogrefinery.com
Cc: shemminger@vyatta.com, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, hadi@cyberus.ca,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipv6: correct the ipv6 option name - Pad0 to Pad1
From: David Miller <davem@davemloft.net>
In-Reply-To: <1337270425-21873-1-git-send-email-eldad@fogrefinery.com>
References: <1337270425-21873-1-git-send-email-eldad@fogrefinery.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 17 May 2012 12:50:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eldad Zack <eldad@fogrefinery.com>
Date: Thu, 17 May 2012 18:00:25 +0200

> The padding destination or hop-by-hop option is called Pad1 and not Pad0.
> 
> See RFC2460 (4.2) or the IANA ipv6-parameters registry:
> http://www.iana.org/assignments/ipv6-parameters/ipv6-parameters.xml
> 
> Signed-off-by: Eldad Zack <eldad@fogrefinery.com>

Applied to net-next.
