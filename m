Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588Ab2AWWYG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 17:24:06 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42670 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253Ab2AWWYE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 17:24:04 -0500
MIME-Version: 1.0
In-Reply-To: <20120123.134352.1621146585245670953.davem@davemloft.net>
References: <3900291.2831326843194846.JavaMail.root@5-MeO-DMT.ynet.sk>
 <CAGsizzLUwA_=fZFX-4ZnYU4K-nj1A2DV_BZKOMKxgQDh2Rs54g@mail.gmail.com>
 <1327327999.2525.23.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <20120123.134352.1621146585245670953.davem@davemloft.net>
From: =?ISO-8859-2?Q?=A9tefan_Gula?= <steweg@ynet.sk>
Date: Mon, 23 Jan 2012 23:23:43 +0100
X-Google-Sender-Auth: ols-pWre_8A8vfZnYRyHQY0DV4E
Message-ID: <CAGsizzJnQ6b6eSC0ZnAtFguU7_xDfWFPSY6L4DWXc24F+Ts2XQ@mail.gmail.com>
Subject: Re: [patch v4, kernel version 3.2.1] net/ipv4/ip_gre: Ethernet
 multipoint GRE over IP
To: David Miller <davem@davemloft.net>
Cc: eric.dumazet@gmail.com, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/23 David Miller <davem@davemloft.net>:
> From: Eric Dumazet <eric.dumazet@gmail.com>
> Date: Mon, 23 Jan 2012 15:13:19 +0100
>
>> Le lundi 23 janvier 2012 à 14:12 +0100, Štefan Gula a écrit :
>>
>>> is there anything else needed from my side to get this code into the
>>> kernel or should I only wait for the maintainers to check it?
>>
>> net-next is/was not yet opened, you shall wait for the good time frame.
>>
>> Dont copy/paste a big message only to add one sentence at its end, its
>> really a waste of time for many of us.
>
> Also you were told of other ways to achieve the things you want to do,
> and I haven't seen any reasonable response that supports still adding
> this new code.
I am sorry about the mistakes I did (still new to kernel submitting
processes). I believe that I also explain to everybody who says
something similar that it is not entirely true and probably never will
be as none of the current SW allows you to create L2 Ethernet
Multipoint VPN solution in such simple way as almost all requires to
run special kind of software in user-space to provide control-plane
for such feature to work. This software must be able to run on various
platforms/architectures which makes it sometimes problematic. My
solution doesn't need this at all and extends the capability of gretap
interfaces in proper manner to be aligned with other forwarding
engines of gretap interfaces. I already have at least one successful
test done in other environment other than my own. So I assume some
people like this approach better than other solutions. For them and
also for myself, I believe it should be added.
