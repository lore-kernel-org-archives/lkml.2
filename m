Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571Ab2HOD3a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 23:29:30 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31419 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850Ab2HOD32 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 23:29:28 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6803"; a="223107373"
X-IronPort-AV: E=Sophos;i="4.77,770,1336374000"; 
   d="scan'208";a="282243928"
From: "Ren, Cloud" <cjren@qca.qualcomm.com>
To: Stephen Hemminger <shemminger@vyatta.com>
CC: "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        qca-linux-team <qca-linux-team@qualcomm.com>,
        nic-devel <nic-devel@qualcomm.com>,
        "Huang, Xiong" <xiong@qca.qualcomm.com>,
        "Hao-Ran Liu(Joseph Liu)" <hao-ran.liu@canonical.com>,
        Joe Perches <joe@perches.com>,
        "Rodriguez, Luis" <rodrigue@qca.qualcomm.com>
Subject: RE: [PATCH] net: add new QCA alx ethernet driver
Thread-Topic: [PATCH] net: add new QCA alx ethernet driver
Thread-Index: AQHNeAL56PRqpmernk28qOEelr0rNJdaOHXg
Date: Wed, 15 Aug 2012 03:29:26 +0000
Message-ID: <6349D7A510622448B1BA0967850A84380136A1EF@NASANEXD02D.na.qualcomm.com>
References: <1344507270-2907-1-git-send-email-cjren@qca.qualcomm.com>
 <20120811135044.529a7081@nehalam.linuxnetplumber.net>
In-Reply-To: <20120811135044.529a7081@nehalam.linuxnetplumber.net>
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

>> +	strncpy(netdev->name, pci_name(pdev), sizeof(netdev->name) - 1);
>> ...
>> +	strcpy(netdev->name, "eth%d");
>> +	retval = register_netdev(netdev);
>
>The strcpy is unnecessary, alloc_etherdev already sets that.

The strcpy is useful. netdev->name is set as pci_name in front. So the strcpy restores it.

Thanks
cloud

