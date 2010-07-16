Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187Ab0GPRdh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 13:33:37 -0400
Received: from mga11.intel.com ([192.55.52.93]:42412 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754249Ab0GPRdg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 13:33:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,215,1278313200"; 
   d="scan'208";a="586857130"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: Ben Greear <greearb@candelatech.com>, "H. Peter Anvin" <hpa@zytor.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Fri, 16 Jul 2010 10:33:34 -0700
Subject: RE: Regression:  2.6.34 boot fails on E5405 system, bisected:
  de08e2c26
Thread-Topic: Regression:  2.6.34 boot fails on E5405 system, bisected:
  de08e2c26
Thread-Index: AcskPBnOimWJbeWOSCCnXDm/Glc6dAA0LXfQ
Message-ID: <43F901BD926A4E43B106BF17856F0755EA9619B5@orsmsx508.amr.corp.intel.com>
References: <4C3D067C.10507@candelatech.com>
	<4C3D101E.5010605@candelatech.com>
	<20100713191958.260478c0@virtuousgeek.org>	<4C3E077C.9040609@zytor.com>
 <20100714115904.7004be74@virtuousgeek.org>
 <43F901BD926A4E43B106BF17856F0755EA8EEA9B@orsmsx508.amr.corp.intel.com>
 <4C3E162C.4040900@zytor.com> <4C3F396B.7080106@candelatech.com>
In-Reply-To: <4C3F396B.7080106@candelatech.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HPA,
If you have not done it already, I can generate a patch against tip tree
and do some testing on it today.

Thanks,

Jacob

>-----Original Message-----
>From: Ben Greear [mailto:greearb@candelatech.com]
>Sent: Thursday, July 15, 2010 9:38 AM
>To: H. Peter Anvin
>Cc: Pan, Jacob jun; Jesse Barnes; linux-kernel
>Subject: Re: Regression: 2.6.34 boot fails on E5405 system, bisected:
>de08e2c26
>
>On 07/14/2010 12:55 PM, H. Peter Anvin wrote:
>> On 07/14/2010 12:01 PM, Pan, Jacob jun wrote:
>>>
>>> Can we use PCI_EXT_CAP_NEXT to replace this line?
>>> pos = (pcie_cap>>  20)&  0xffc
>>>
>>
>> Presumably, I haven't checked the definition of that macro, but that
>> would be the logical semantics.
>>
>> 	-hpa
>
>Are one of you guys going to submit a fix upstream (and hopefully
>to stable)?  Since you guys actually understand the code, probably
>best that you do it....
>
>Thanks,
>Ben
>
>--
>Ben Greear <greearb@candelatech.com>
>Candela Technologies Inc  http://www.candelatech.com

