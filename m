Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757682Ab2FGVbI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 17:31:08 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:1783 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757603Ab2FGVbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 17:31:04 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6735"; a="198888906"
X-IronPort-AV: E=Sophos;i="4.75,732,1330934400"; 
   d="scan'208";a="266605122"
From: "Huang, Xiong" <xiong@qca.qualcomm.com>
To: Thomas Meyer <thomas@m3y3r.de>, Jonathan Nieder <jrnieder@gmail.com>
CC: Eric Dumazet <eric.dumazet@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "jcliburn@gmail.com" <jcliburn@gmail.com>,
        "chris.snook@gmail.com" <chris.snook@gmail.com>,
        netdev <netdev@vger.kernel.org>, Josh Boyer <jwboyer@gmail.com>
Subject: RE: NETDEV WATCHDOG: eth0 (atl1c): transmit queue 0 timed out
Thread-Topic: NETDEV WATCHDOG: eth0 (atl1c): transmit queue 0 timed out
Thread-Index: AQHM6utoxd0vuZvRWUqx1poV48KQ6ZY/eLQAgAi79oCAAAUFgIAEyVOAgADztYCAn6JNAIACWxyAgAAfRxA=
Date: Thu, 7 Jun 2012 21:30:53 +0000
Message-ID: <157393863283F442885425D2C454285623D871BC@nasanexd02a.na.qualcomm.com>
References: <1329063403.1449.14.camel@localhost.localdomain>
	 <CA+5PVA52+0vOMF6+tvMPkgzhdTKJRQnrjD4FfVmBZs0TMDJ5cg@mail.gmail.com>
	 <1329204997.24837.15.camel@edumazet-laptop>
	 <1329366846.5646.1.camel@edumazet-laptop>
	 <1329847015.5133.4.camel@localhost.localdomain>
	 <1329848093.18384.35.camel@edumazet-laptop>
	 <1330111229.15610.50.camel@edumazet-laptop>
	 <1330163565.1419.5.camel@localhost.localdomain>
	 <20120606003856.GA7839@burratino>
 <1339072653.3018.9.camel@localhost.localdomain>
In-Reply-To: <1339072653.3018.9.camel@localhost.localdomain>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [199.106.114.130]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q57LVEtE021050

Thomas
    Are you using the latest atl1c code in kernel ? recently, I have updated some hw configuration.

Thanks
Xiong

> -----Original Message-----
> From: netdev-owner@vger.kernel.org [mailto:netdev-
> owner@vger.kernel.org] On Behalf Of Thomas Meyer
> Sent: Thursday, June 07, 2012 20:38
> To: Jonathan Nieder
> Cc: Eric Dumazet; Linux Kernel Mailing List; jcliburn@gmail.com;
> chris.snook@gmail.com; netdev; Josh Boyer
> Subject: Re: NETDEV WATCHDOG: eth0 (atl1c): transmit queue 0 timed out
> 
> Am Dienstag, den 05.06.2012, 19:38 -0500 schrieb Jonathan Nieder:
> > In February, 2012, Thomas Meyer wrote:
> > > Am Freitag, den 24.02.2012, 20:20 +0100 schrieb Eric Dumazet:
> >
> > >> Here is a cumulative patch to hopefuly remove the races in this
> > >> driver, could you please test it ?
> > [...]
> > > just building a 3.2.7 kernel with your patch applied. I will watch
> > > out for the warning in the next days.
> >
> > Well, did it work? :)
> 
> Hi Jonathan,
> 
> no it didn't. I still get these warnings.
> 
> wiht kind regards
> thomas
> 
> >
> > In suspense,
> > Jonathan
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in the body
> of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
