Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751915Ab2HOFjc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 01:39:32 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18295 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab2HOFjN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 01:39:13 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6803"; a="225420483"
X-IronPort-AV: E=Sophos;i="4.77,771,1336374000"; 
   d="scan'208";a="368776447"
From: "Ren, Cloud" <cjren@qca.qualcomm.com>
To: David Miller <davem@davemloft.net>
CC: "shemminger@vyatta.com" <shemminger@vyatta.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        qca-linux-team <qca-linux-team@qualcomm.com>,
        nic-devel <nic-devel@qualcomm.com>,
        "Huang, Xiong" <xiong@qca.qualcomm.com>,
        "hao-ran.liu@canonical.com" <hao-ran.liu@canonical.com>,
        "joe@perches.com" <joe@perches.com>,
        "Rodriguez, Luis" <rodrigue@qca.qualcomm.com>
Subject: RE: [PATCH] net: add new QCA alx ethernet driver
Thread-Topic: [PATCH] net: add new QCA alx ethernet driver
Thread-Index: AQHNeAL56PRqpmernk28qOEelr0rNJdaOHXggACbuAD//4tVMA==
Date: Wed, 15 Aug 2012 05:39:11 +0000
Message-ID: <6349D7A510622448B1BA0967850A84380136A218@NASANEXD02D.na.qualcomm.com>
References: <1344507270-2907-1-git-send-email-cjren@qca.qualcomm.com>
	<20120811135044.529a7081@nehalam.linuxnetplumber.net>
	<6349D7A510622448B1BA0967850A84380136A1EF@NASANEXD02D.na.qualcomm.com>
 <20120814.223258.1180104882398843954.davem@davemloft.net>
In-Reply-To: <20120814.223258.1180104882398843954.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.48.1]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller [mailto:davem@davemloft.net]
Sent: Wednesday, August 15, 2012 1:33 PM

>From: "Ren, Cloud" <cjren@qca.qualcomm.com>
>Date: Wed, 15 Aug 2012 03:29:26 +0000
>
>>>> +	strncpy(netdev->name, pci_name(pdev), sizeof(netdev->name) - 1);
>>>> ...
>>>> +	strcpy(netdev->name, "eth%d");
>>>> +	retval = register_netdev(netdev);
>>>
>>>The strcpy is unnecessary, alloc_etherdev already sets that.
>>
>> The strcpy is useful. netdev->name is set as pci_name in front. So the strcpy
>restores it.
>
>Are you doing this just to influence the initial driver log messages?

 Yes.

>
>Don't do that, it's gross.

Ok, I will remove it.
