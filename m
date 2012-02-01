Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219Ab2BAT7t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 14:59:49 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44596 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756731Ab2BAT7r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 14:59:47 -0500
MIME-Version: 1.0
In-Reply-To: <20120201.143455.1014458821077044311.davem@davemloft.net>
References: <21672990.651327923923151.JavaMail.root@5-MeO-DMT.ynet.sk>
 <13688762.701327924297781.JavaMail.root@5-MeO-DMT.ynet.sk> <20120201.143455.1014458821077044311.davem@davemloft.net>
From: =?ISO-8859-2?Q?=A9tefan_Gula?= <steweg@ynet.sk>
Date: Wed, 1 Feb 2012 20:59:27 +0100
X-Google-Sender-Auth: ccgMkwn_ZsYuSPzOJHeseVtmmsM
Message-ID: <CAGsizzJc9pJ-xsX12JNxZhFBC7VzF6QkRZMoPopK1nsVtA0AeA@mail.gmail.com>
Subject: Re: [patch v7, kernel version 3.2.1] Source mode for macvlan interface
To: David Miller <davem@davemloft.net>
Cc: kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/2/1 David Miller <davem@davemloft.net>:
> From: Stefan Gula <steweg@ynet.sk>
> Date: Mon, 30 Jan 2012 12:51:37 +0100 (CET)
>
>> V6 changes:
>>  - removed ability to fill the list of macaddr per link to fix the
>>    issue of netlink skb size. This can be added back by using separate
>>    netlink dumper in kernel and parse inside iproute2 codes. Those codes
>>    are beyond my abilities so if anyone actually need that feel free to
>>    help.
>
> I'm not applying this patch until you add an appropriate way to query
> the setting, working around the link dump SKB size issue by not providing
> a way to query the information at all is not acceptable.
Ok
