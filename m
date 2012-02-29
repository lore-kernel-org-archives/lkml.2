Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757589Ab2B2CTJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 21:19:09 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:3012 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112Ab2B2CTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 21:19:06 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6634"; a="165051943"
X-IronPort-AV: E=Sophos;i="4.73,496,1325491200"; 
   d="scan'208";a="206627558"
From: "Huang, Xiong" <xiong@qca.qualcomm.com>
To: "Rodriguez, Luis" <rodrigue@qca.qualcomm.com>,
        David Miller <davem@davemloft.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        qca-linux-team <qca-linux-team@qualcomm.com>,
        nic-devel <nic-devel@qualcomm.com>,
        "Giori, Kathy" <kgiori@qca.qualcomm.com>,
        "chris.snook@gmail.com" <chris.snook@gmail.com>,
        "Olivari, Mathieu" <mathieu@qca.qualcomm.com>,
        "Huntsman, Bryan" <bryanh@quicinc.com>
Subject: RE: [PATCH] net: add QCA alx Ethernet driver
Thread-Topic: [PATCH] net: add QCA alx Ethernet driver
Thread-Index: AQHM9oR7kTu/A5Gy+kqKXc430uKtxJZTowaAgAAFPID//3p5IA==
Date: Wed, 29 Feb 2012 02:19:05 +0000
Message-ID: <157393863283F442885425D2C4542856194154FC@nasanexd02a.na.qualcomm.com>
References: <1330480210-30470-1-git-send-email-rodrigue@qca.qualcomm.com>
 <20120228.205347.1718771650331094141.davem@davemloft.net>
 <CAB=NE6VXyQ-k1Sm3Xf_ABE35+PHSoNqX=AJpLBjNu0sdAdnY4g@mail.gmail.com>
In-Reply-To: <CAB=NE6VXyQ-k1Sm3Xf_ABE35+PHSoNqX=AJpLBjNu0sdAdnY4g@mail.gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id q1T2JIOo031167

Hi David
     The code related to hardware of atl1c is quite diff with that in our hand, every time we take much time to find which part should be 
revised for one bug/issue found on other platform/OSes. the new driver make it easy to fix and support new chipset as well.

     We reviewed all patches that applied to atl1c and added it to the alx  during coding. And did tests for both new and old drivers
You could find the result here:  http://www.linuxfoundation.org/collaborate/workgroups/networking/alx


Best Regards
-Xiong

 -----Original Message-----
> From: mcgrof@gmail.com [mailto:mcgrof@gmail.com] On Behalf Of Luis R.
> Rodriguez
> Sent: Wednesday, February 29, 2012 10:13
> To: David Miller
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; qca-linux-team; nic-
> devel; Giori, Kathy; chris.snook@gmail.com; Olivari, Mathieu; Huntsman, Bryan
> Subject: Re: [PATCH] net: add QCA alx Ethernet driver
> 
> On Tue, Feb 28, 2012 at 5:53 PM, David Miller <davem@davemloft.net> wrote:
> > From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
> > Date: Tue, 28 Feb 2012 17:50:09 -0800
> >
> >> The next patch adds the new QCA alx Ethernet driver that supercedes
> >> the atl1c Ethernet driver. For details please read the commit log of
> >> the patch. Given the size you can download the patch from:
> >
> > What's wrong with making evolutionary fixes to atl1c instead of
> > replacing it wholesale?
> >
> > This isn't the way to do it Luis.
> 
> I *vehemently* tried to change direction of this driver development to do
> exactly what you stated when this driver was first posted last year in October of
> 2011 [0]. I could not get commitment on that route mainly due to the large delta
> and lack of resources to address this. I knew this would still be a hard sale but
> what I proposed was a comprise --  consider a replacement *if* we can get QCA
> engineers tasked to work upstream and committed to fixing *all* issues
> reported,
> *and* also properly tested and compared drivers.
> 
> The other option we had reviewed here was to get this into staging but the
> garbage driver code is all resolved now. Its your call. This is the best I could get
> commitment and resources on.
> 
> [0] http://markmail.org/message/7dk7ltdcdlx5ksu6
> 
>   Luis
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
