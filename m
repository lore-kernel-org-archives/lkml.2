Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406Ab2BPHJi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 02:09:38 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18842 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757237Ab2BPHJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 02:09:34 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6621"; a="163612718"
X-IronPort-AV: E=Sophos;i="4.73,426,1325491200"; 
   d="scan'208";a="257852646"
From: "Huang, Xiong" <xiong@qca.qualcomm.com>
To: Eric Dumazet <eric.dumazet@gmail.com>, Thomas Meyer <thomas@m3y3r.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "jcliburn@gmail.com" <jcliburn@gmail.com>,
        "chris.snook@gmail.com" <chris.snook@gmail.com>,
        netdev <netdev@vger.kernel.org>, Josh Boyer <jwboyer@gmail.com>
Subject: RE: NETDEV WATCHDOG: eth0 (atl1c): transmit queue 0 timed out
Thread-Topic: NETDEV WATCHDOG: eth0 (atl1c): transmit queue 0 timed out
Thread-Index: AQHM7HK8xd0vuZvRWUqx1poV48KQ6ZY/GeuQ
Date: Thu, 16 Feb 2012 07:09:33 +0000
Message-ID: <157393863283F442885425D2C454285619403DEA@nasanexd02a.na.qualcomm.com>
References: <1329063403.1449.14.camel@localhost.localdomain>
	 <CA+5PVA52+0vOMF6+tvMPkgzhdTKJRQnrjD4FfVmBZs0TMDJ5cg@mail.gmail.com>
	 <1329204997.24837.15.camel@edumazet-laptop>
	 <1329366846.5646.1.camel@edumazet-laptop>
	 <C6B7BB6C-D1B8-4454-A2B2-558FCA5B0BBD@m3y3r.de>
 <1329373082.5646.9.camel@edumazet-laptop>
In-Reply-To: <1329373082.5646.9.camel@edumazet-laptop>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.45.230.6]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q1G79h1W021818

Sorry,  the piece of code that related to mark might be introduced by our internal test for multiple queues.
I remember mark could be changed by ip_table rule.

Thanks
Xiong

> -----Original Message-----
> From: netdev-owner@vger.kernel.org [mailto:netdev-owner@vger.kernel.org]
> On Behalf Of Eric Dumazet
> Sent: Thursday, February 16, 2012 14:18
> To: Thomas Meyer
> Cc: Linux Kernel Mailing List; jcliburn@gmail.com; chris.snook@gmail.com;
> netdev; Josh Boyer
> Subject: Re: NETDEV WATCHDOG: eth0 (atl1c): transmit queue 0 timed out
> 
> Le jeudi 16 fÃ©vrier 2012 Ã  07:13 +0100, Thomas Meyer a Ã©crit :
> 
> > Hello Eric,
> >
> > >
> > > Thomas, have you had the chance to test this patch ?
> >
> > Yes, I'm running 3.2.6 with your patch applied for 3 days now. I didn't see
> above warning yet, but the warning was rather seldom, so I'll keep an eye on it
> in the next weeks.
> >
> > Thanks for the patch!
> >
> 
> Thanks for testing !
> 
> Do have any idea of what could set skb mark to 1 on some packets on your
> setup ?
> 
> Some firewall rules or tc rules ?
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in the body of a
> message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
