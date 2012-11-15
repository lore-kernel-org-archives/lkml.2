Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423713Ab2KOU0j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 15:26:39 -0500
Received: from mga11.intel.com ([192.55.52.93]:55887 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423686Ab2KOU0i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 15:26:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,259,1352102400"; 
   d="scan'208";a="247643021"
From: "Dave, Tushar N" <tushar.n.dave@intel.com>
To: Joe Jin <joe.jin@oracle.com>
CC: "e1000-devel@lists.sf.net" <e1000-devel@lists.sf.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mary Mcgrath <mary.mcgrath@oracle.com>
Subject: RE: 82571EB: Detected Hardware Unit Hang
Thread-Topic: 82571EB: Detected Hardware Unit Hang
Thread-Index: AQHNvXnv9zWmKMRSTUSeVhWmoXs8rZfgY6YggAjMYQD//4mJQIAB4wgAgADGiTA=
Date: Thu, 15 Nov 2012 20:26:36 +0000
Message-ID: <061C8A8601E8EE4CA8D8FD6990CEA8913349A0B4@ORSMSX102.amr.corp.intel.com>
References: <509B5038.8090304@oracle.com>
 <061C8A8601E8EE4CA8D8FD6990CEA89133487884@ORSMSX102.amr.corp.intel.com>
 <50A30656.6090508@oracle.com>
 <061C8A8601E8EE4CA8D8FD6990CEA8913348B105@ORSMSX102.amr.corp.intel.com>
 <50A43828.6000702@oracle.com>
In-Reply-To: <50A43828.6000702@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Joe Jin [mailto:joe.jin@oracle.com]
>Sent: Wednesday, November 14, 2012 4:33 PM
>To: Dave, Tushar N
>Cc: e1000-devel@lists.sf.net; netdev@vger.kernel.org; linux-
>kernel@vger.kernel.org; Mary Mcgrath
>Subject: Re: 82571EB: Detected Hardware Unit Hang
>
>On 11/14/12 11:45, Dave, Tushar N wrote:
>>> -----Original Message-----
>>> From: Joe Jin [mailto:joe.jin@oracle.com]
>>> Sent: Tuesday, November 13, 2012 6:48 PM
>>> To: Dave, Tushar N
>>> Cc: e1000-devel@lists.sf.net; netdev@vger.kernel.org; linux-
>>> kernel@vger.kernel.org; Mary Mcgrath
>>> Subject: Re: 82571EB: Detected Hardware Unit Hang
>>>
>>> On 11/09/12 04:35, Dave, Tushar N wrote:
>>>> All devices in path from root complex to 82571, should have *same*
>>>> max
>>> payload size otherwise it can cause hang.
>>>> Can you double check this?
>>>
>>> Hi Tushar,
>>>
>>> Checked with hardware vendor and they said no way to modify the max
>>> payload size from BIOS, can I modify it from driver side?
>>
>> If you want to change value for 82571 device you can do it from eeprom
>but for other upstream devices I am not sure. I will check with my team.
>
>Hi Tushar,
>
>Would you please help to fine the offset of max payload size in eeprom?
>I'd like to have a try to modify it by ethtool.

It is defined using bit 8 of word 0x1A.
Bit value 0 = 128B , bit value 1 = 256B

-Tushar
