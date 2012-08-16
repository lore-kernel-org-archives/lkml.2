Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab2HPCZc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 22:25:32 -0400
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:58192 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380Ab2HPCZa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 22:25:30 -0400
X-Greylist: delayed 371 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Aug 2012 22:25:29 EDT
X-IronPort-AV: E=McAfee;i="5400,1158,6804"; a="257533"
X-IronPort-AV: E=Sophos;i="4.77,775,1336374000"; 
   d="scan'208";a="299387"
From: "Ren, Cloud" <cjren@qca.qualcomm.com>
To: Stephen Hemminger <shemminger@vyatta.com>
CC: David Miller <davem@davemloft.net>,
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
Thread-Index: AQHNeAL56PRqpmernk28qOEelr0rNJdaOHXggACbuAD//4tVMIABE8cAgABGuWA=
Date: Thu, 16 Aug 2012 02:19:16 +0000
Message-ID: <6349D7A510622448B1BA0967850A84380136B263@NALASEXD02B.na.qualcomm.com>
References: <1344507270-2907-1-git-send-email-cjren@qca.qualcomm.com>
	<20120811135044.529a7081@nehalam.linuxnetplumber.net>
	<6349D7A510622448B1BA0967850A84380136A1EF@NASANEXD02D.na.qualcomm.com>
	<20120814.223258.1180104882398843954.davem@davemloft.net>
	<6349D7A510622448B1BA0967850A84380136A218@NASANEXD02D.na.qualcomm.com>
 <20120815080226.388ea856@nehalam.linuxnetplumber.net>
In-Reply-To: <20120815080226.388ea856@nehalam.linuxnetplumber.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.39.5]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger [mailto:shemminger@vyatta.com]
Sent: Wednesday, August 15, 2012 11:02 PM

>> >>>> +	strncpy(netdev->name, pci_name(pdev), sizeof(netdev->name) -
>1);
>> >>>> ...
>> >>>> +	strcpy(netdev->name, "eth%d");
>> >>>> +	retval = register_netdev(netdev);
>> >>>
>> >>>The strcpy is unnecessary, alloc_etherdev already sets that.
>> >>
>> >> The strcpy is useful. netdev->name is set as pci_name in front. So the strcpy
>> >restores it.
>> >
>> >Are you doing this just to influence the initial driver log messages?
>>
>>  Yes.
>>
>> >
>> >Don't do that, it's gross.
>>
>> Ok, I will remove it.
>
>Before the driver is registered, use dev_info() type of logging.

Ok, I will do.



 


