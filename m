Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667Ab1GTCpc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 22:45:32 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:40039 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752433Ab1GTCpa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 22:45:30 -0400
X-SpamScore: -22
X-BigFish: VPS-22(zz936eK9371M542M1432N98dKzz1202hzz8275bhz2dh2a8h668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPVD:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
From: "Zhang, Sonic" <Sonic.Zhang@analog.com>
To: Joe Perches <joe@perches.com>, Sonic Zhang <sonic.adi@gmail.com>
CC: Alan Cox <alan@linux.intel.com>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 19 Jul 2011 22:44:36 -0400
Subject: RE: [PATCH 1/2] serial:blackfin: Correct coding style in bfin
 serial driver.
Thread-Topic: [PATCH 1/2] serial:blackfin: Correct coding style in bfin
 serial driver.
Thread-Index: AcxGKG1EC22xqwjgQRWNFzIui1O4kAAX3vsg
Message-ID: <DB904C5425BA6F4E8424B3B51A1414D16C9CB6EE64@NWD2CMBX1.ad.analog.com>
References: <1311070165-29402-1-git-send-email-sonic.adi@gmail.com>
 <1311089315.2286.157.camel@Joe-Laptop>
In-Reply-To: <1311089315.2286.157.camel@Joe-Laptop>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: analog.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: Joe Perches [mailto:joe@perches.com]
>Sent: Tuesday, July 19, 2011 11:29 PM
>To: Sonic Zhang
>Cc: Alan Cox; linux-serial@vger.kernel.org;
>linux-kernel@vger.kernel.org; Zhang, Sonic
>Subject: Re: [PATCH 1/2] serial:blackfin: Correct coding style
>in bfin serial driver.
>
>On Tue, 2011-07-19 at 18:09 +0800, Sonic Zhang wrote:
>> From: Sonic Zhang <sonic.zhang@analog.com>
>[]
>> @@ -1091,10 +1090,18 @@
>bfin_serial_console_get_options(struct bfin_serial_port *uart,
>int *baud,
>>                              *parity = 'o';
>>              }
>>              switch (lcr & 0x03) {
>> -                    case 0: *bits = 5; break;
>> -                    case 1: *bits = 6; break;
>> -                    case 2: *bits = 7; break;
>> -                    case 3: *bits = 8; break;
>> +            case 0:
>> +                    *bits = 5;
>> +                    break;
>> +            case 1:
>> +                    *bits = 6;
>> +                    break;
>> +            case 2:
>> +                    *bits = 7;
>> +                    break;
>> +            case 3:
>> +                    *bits = 8;
>> +                    break;
>>              }
>
>Maybe just:
>       *bits = 5 + (lcr & 3);
>

Could be a new patch.

Sonic
>
>

