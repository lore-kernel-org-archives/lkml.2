Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932654Ab2KNDni (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 22:43:38 -0500
Received: from mga01.intel.com ([192.55.52.88]:43226 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932464Ab2KNDng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 22:43:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,247,1352102400"; 
   d="scan'208";a="248767316"
From: "Dave, Tushar N" <tushar.n.dave@intel.com>
To: Li Yu <raise.sail@gmail.com>
CC: Joe Jin <joe.jin@oracle.com>,
        "e1000-devel@lists.sf.net" <e1000-devel@lists.sf.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mary Mcgrath <mary.mcgrath@oracle.com>
Subject: RE: 82571EB: Detected Hardware Unit Hang
Thread-Topic: 82571EB: Detected Hardware Unit Hang
Thread-Index: AQHNvXnv9zWmKMRSTUSeVhWmoXs8rZfgY6YggAjaLYD//3rpUA==
Date: Wed, 14 Nov 2012 03:43:33 +0000
Message-ID: <061C8A8601E8EE4CA8D8FD6990CEA8913348B0E7@ORSMSX102.amr.corp.intel.com>
References: <509B5038.8090304@oracle.com>
 <061C8A8601E8EE4CA8D8FD6990CEA89133487884@ORSMSX102.amr.corp.intel.com>
 <50A311E9.9030702@gmail.com>
In-Reply-To: <50A311E9.9030702@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qAE3hgw1019768

>-----Original Message-----
>From: Li Yu [mailto:raise.sail@gmail.com]
>Sent: Tuesday, November 13, 2012 7:37 PM
>To: Dave, Tushar N
>Cc: Joe Jin; e1000-devel@lists.sf.net; netdev@vger.kernel.org; linux-
>kernel@vger.kernel.org; Mary Mcgrath
>Subject: Re: 82571EB: Detected Hardware Unit Hang
>
>äº 2012å¹´11æœˆ09æ—¥ 04:35, Dave, Tushar N å†™é“:
>>> -----Original Message-----
>>> From: netdev-owner@vger.kernel.org
>>> [mailto:netdev-owner@vger.kernel.org]
>>> On Behalf Of Joe Jin
>>> Sent: Wednesday, November 07, 2012 10:25 PM
>>> To: e1000-devel@lists.sf.net
>>> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Mary
>>> Mcgrath
>>> Subject: 82571EB: Detected Hardware Unit Hang
>>>
>>> Hi list,
>>>
>>> IHAC reported "82571EB Detected Hardware Unit Hang" on HP ProLiant
>>> DL360 G6, and have to reboot the server to recover:
>>>
>>> e1000e 0000:06:00.1: eth3: Detected Hardware Unit Hang:
>>>   TDH                  <1a>
>>>   TDT                  <1a>
>>>   next_to_use          <1a>
>>>   next_to_clean        <18>
>>> buffer_info[next_to_clean]:
>>>   time_stamp           <10047a74e>
>>>   next_to_watch        <18>
>>>   jiffies              <10047a88c>
>>>   next_to_watch.status <1>
>>> MAC Status             <80383>
>>> PHY Status             <792d>
>>> PHY 1000BASE-T Status  <3800>
>>> PHY Extended Status    <3000>
>>> PCI Status             <10>
>>>
>>> With newer kernel 2.0.0.1 the issue still reproducible.
>>>
>>> Device info:
>>> 06:00.1 Ethernet controller: Intel Corporation 82571EB Gigabit
>>> Ethernet Controller (Copper) (rev 06)
>>> 06:00.1 0200: 8086:10bc (rev 06)
>>>
>>> I compared lspci output before and after the issue, different as below:
>>> 06:00.1 Ethernet controller: Intel Corporation 82571EB Gigabit
>>> Ethernet Controller (Copper) (rev 06)
>>> 	Subsystem: Hewlett-Packard Company NC364T PCI Express Quad Port
>>> Gigabit Server Adapter
>>> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+
>>> Stepping- SERR- FastB2B- DisINTx-
>>> -	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
>>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>> +	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
>>> +<TAbort- <MAbort- >SERR- <PERR- INTx+
>>
>> Are you sure this is not similar issue as before that you reported.
>> i.e.
>> On Mon, 2012-07-09 at 16:51 +0800, Joe Jin wrote:
>>> I'm seeing a Unit Hang even with the latest e1000e driver 2.0.0 when
>>> doing scp test. this issue is easy do reproduced on SUN FIRE X2270
>>> M2, just copy a big file (>500M) from another server will hit it at
>once.
>>
>> All devices in path from root complex to 82571, should have *same* max
>payload size otherwise it can cause hang.
>> Can you double check this?
>>
>
>We also found such hang problem on 82599EB (ixgbe driver) in RHEL6.3
>kernel, we ever tried to upgrade to latest version (3.8.21 or 3.10.17),
>but it still happens.
>
>Is it probably also due to wrong "max payload size" set in BIOS?
>
It could be or could not be. I would suggest please create another thread with that issue as these two devices are significantly different.

-Tushar
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
