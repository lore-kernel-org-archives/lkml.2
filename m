Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770Ab2AWSqs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 13:46:48 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:57323 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692Ab2AWSqr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 13:46:47 -0500
Date: Mon, 23 Jan 2012 13:43:52 -0500 (EST)
Message-Id: <20120123.134352.1621146585245670953.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: steweg@ynet.sk, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch v4, kernel version 3.2.1] net/ipv4/ip_gre: Ethernet
 multipoint GRE over IP
From: David Miller <davem@davemloft.net>
In-Reply-To: <1327327999.2525.23.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <3900291.2831326843194846.JavaMail.root@5-MeO-DMT.ynet.sk>
	<CAGsizzLUwA_=fZFX-4ZnYU4K-nj1A2DV_BZKOMKxgQDh2Rs54g@mail.gmail.com>
	<1327327999.2525.23.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 23 Jan 2012 10:44:01 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Mon, 23 Jan 2012 15:13:19 +0100

> Le lundi 23 janvier 2012 à 14:12 +0100, ¦tefan Gula a écrit :
> 
>> is there anything else needed from my side to get this code into the
>> kernel or should I only wait for the maintainers to check it?
> 
> net-next is/was not yet opened, you shall wait for the good time frame.
> 
> Dont copy/paste a big message only to add one sentence at its end, its
> really a waste of time for many of us.

Also you were told of other ways to achieve the things you want to do,
and I haven't seen any reasonable response that supports still adding
this new code.
