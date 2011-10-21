Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842Ab1JUCWO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 22:22:14 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:37304 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527Ab1JUCWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 22:22:12 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6505"; a="129617086"
X-IronPort-AV: E=Sophos;i="4.69,383,1315206000"; 
   d="scan'208";a="147065909"
From: "Ren, Cloud" <cjren@qca.qualcomm.com>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
CC: David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [patch net-next]alx: Atheros AR8131/AR8151/AR8152/AR8161
 Ethernet driver
Thread-Topic: [patch net-next]alx: Atheros AR8131/AR8151/AR8152/AR8161
 Ethernet driver
Thread-Index: AQHMjvQO9EGPKqVzTkOxaT8937sMf5WFYLyA//+Sl8CAAHhsAP//jNYAgAEuCoD//+F0gA==
Date: Fri, 21 Oct 2011 02:21:44 +0000
Message-ID: <6349D7A510622448B1BA0967850A8438011CC7CA@nasanexd02d.na.qualcomm.com>
References: <1319093184-19696-1-git-send-email-cloud.ren@Atheros.com>
 <20111020.044541.970282389722164761.davem@davemloft.net>
 <6349D7A510622448B1BA0967850A8438011CC21D@nasanexd02d.na.qualcomm.com>
 <20111020.052506.373437241768777548.davem@davemloft.net>
 <6349D7A510622448B1BA0967850A8438011CC2A0@nasanexd02d.na.qualcomm.com>
 <CAB=NE6W6Gc+dN3SzX00VwO9iheemNzhRQ34KuvMtZsBqVJQhJQ@mail.gmail.com>
In-Reply-To: <CAB=NE6W6Gc+dN3SzX00VwO9iheemNzhRQ34KuvMtZsBqVJQhJQ@mail.gmail.com>
Accept-Language: en-US
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id p9L2MQM3023383

>On Thu, Oct 20, 2011 at 2:48 AM, Ren, Cloud <cjren@qca.qualcomm.com>
>wrote:
>>
>>>From: "Ren, Cloud" <cjren@qca.qualcomm.com>
>>>Date: Thu, 20 Oct 2011 09:23:07 +0000
>>>
>>>> As you saw, should I do the two following steps?
>>>> 1. I firstly try to submit code to linux-staging.git.
>>>> 2. After the driver have been accepted by Â linux-staging.git, I
>>>> submit to net-
>>>next.git again.
>>>
>>>You submit and get it into staging so that it can sit there for some
>>>time and get reviewed and improved by others.
>>>
>>>One doesn't submit directly to net-next right after it gets into
>>>staging, staging is a place where your driver lives while it still
>>>smelly funky and needs more work.
>>
>> The driver will support the next generation NICs of Atheros.
>> Meanwhile, the driver can also have better optimization for AR8131 and
>> AR8151 than atl1c. For some reason, we don't plan to patch atl1c
>> driver to support our new NIC, such as AR8161. So I hope the driver
>> can stay in net-next in the end. Of course, I will be responsible for modify
>source code and let it match kernel requirements.
>
>Cloud,
>
>If you want to skip staging (which I recommend) then you need to address all
>upstream concerns expressed. Given that you indicate that you will be
>working on following up with the driver until its acceptable upstream my
>recommendation is either to clean up the driver very well and review it
>internally at Atheros prior to a public submission *or* just dump into staging
>and get the benefit of community cleanup and eventually wait until it is ready
>for proper upstream. If you want internal private review at Atheros you can
>use the internal private ath9k-devel list.
>
>Also are you going to maintain the older atlx drivers? While at it can you clear
>up who maintains what as far as Atheros is concerned for Ethernet?
>
>  Luis

Dear Luis

Thanks for your suggestions. I would rather do an internal review than only submit to staging.
Alx driver is one of the most important drivers for Atheros Ethernet. It's easier to maintain. 
Because it shares many codes with other drivers on different OSs, it can be convenient to patch
some issues which are found on different OSs.

I'm going to maintain alx linux driver. alx linux driver can support all NICs which atl1c linux driver supports.
So we don't plan to maintain atl1c driver. atl1e and atlx driver are also maintained by me. But maybe I can
not response requests for those drivers on time, because sometimes I am busy at alx driver.

cloud


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
