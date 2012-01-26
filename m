Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab2AZSdT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 13:33:19 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:33348 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122Ab2AZSdQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 13:33:16 -0500
Date: Thu, 26 Jan 2012 13:30:33 -0500 (EST)
Message-Id: <20120126.133033.964571202129052712.davem@davemloft.net>
To: steweg@ynet.sk
Cc: jesse@nicira.com, joseph.glanville@orionvm.com.au, eric.dumazet@gmail.com,
        kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch v4, kernel version 3.2.1] net/ipv4/ip_gre: Ethernet
 multipoint GRE over IP
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAGsizzLYxsc2MGxF7yK_QzS+3bexHa1F_6+NE87u3F18m7=R1g@mail.gmail.com>
References: <CAGsizzJnRy74ni-HH=5q1VR4g6sfDPg9SFw4UKgSjJjkSR8OJA@mail.gmail.com>
	<20120125.203746.1977019610549185259.davem@davemloft.net>
	<CAGsizzLYxsc2MGxF7yK_QzS+3bexHa1F_6+NE87u3F18m7=R1g@mail.gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 26 Jan 2012 10:30:37 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ¦tefan Gula <steweg@ynet.sk>
Date: Thu, 26 Jan 2012 11:57:30 +0100

> 2012/1/26 David Miller <davem@davemloft.net>:
>> From: ¦tefan Gula <steweg@ynet.sk>
>> Date: Wed, 25 Jan 2012 23:57:18 +0100
>>
>>> The performance is one of the most critical thing why I have chosen to
>>> build kernel patch in the first place instead of some user-space app.
>>> If I used this approach, I would probably end up with patch for
>>> OpenVPN project instead in that time. I am not telling that
>>> openvswitch is not a good place for prototyping, but I believe that
>>> this patch is beyond that border as it successfully run in environment
>>> with more 98 linux-based APs, used for 4K+ users, with no issue for
>>> more than 2 years. The performance results from Joseph Glanville even
>>> adds value to it. So I still don't get the point, why my patch and
>>> openvswitch cannot coexists in the kernel together and let user/admin
>>> to choose to correct solution for him/her.
>>
>> You don't even know if openvswitch could provide acceptable levels
>> of performance, because you haven't even tried.
>>
>> I'm not applying your patch.
> Performance of any user-space application is lower than performance of
> something running purely inside the kernel-space only. So still don't
> see any valid reason, why it simply cannot coexists as it doesn't
> breaks any existing functionality at all?

The only userspace component is setting up the rules, the actual
packet processing occurs in the openvswitch kernel code.

Are you really unable to understand this?
