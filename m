Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446Ab1KQCpv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 21:45:51 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:53360 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461Ab1KQCpu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 21:45:50 -0500
X-SpamScore: -19
X-BigFish: VPS-19(zz9371K936eK542M1432N98dKzz1202hzz8275bh8275dhz32i2a8h668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPVD:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
From: "Zhang, Sonic" <Sonic.Zhang@analog.com>
To: Joe Perches <joe@perches.com>, Sonic Zhang <sonic.adi@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>
Date: Wed, 16 Nov 2011 21:45:45 -0500
Subject: RE: [PATCH] MAINTAINERS: update maintainers for blackfin arch and
 drivers.
Thread-Topic: [PATCH] MAINTAINERS: update maintainers for blackfin arch and
 drivers.
Thread-Index: AcykYXy2WJYgVMUKTda06QLhdsWMrAAcCBUg
Message-ID: <DB904C5425BA6F4E8424B3B51A1414D16D3BC319BE@NWD2CMBX1.ad.analog.com>
References: <1321429708-13862-1-git-send-email-sonic.adi@gmail.com>
 <1321449126.16478.2.camel@Joe-Laptop>
In-Reply-To: <1321449126.16478.2.camel@Joe-Laptop>
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
>Sent: Wednesday, November 16, 2011 9:12 PM
>To: Sonic Zhang
>Cc: LKML; uclinux-dist-devel@blackfin.uclinux.org; Zhang, Sonic
>Subject: Re: [PATCH] MAINTAINERS: update maintainers for
>blackfin arch and drivers.
>
>On Wed, 2011-11-16 at 15:48 +0800, Sonic Zhang wrote:
>> From: Sonic Zhang <sonic.zhang@analog.com>
>>
>> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
>> ---
>>  MAINTAINERS |    4 +---
>>  1 files changed, 1 insertions(+), 3 deletions(-)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS index 7f6bc29..86941ba 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -1481,6 +1481,7 @@ F:     fs/bfs/
>>  F:  include/linux/bfs_fs.h
>>
>>  BLACKFIN ARCHITECTURE
>> +M:  Bob Liu <lliubbo@kernel.org>
>>  M:  Mike Frysinger <vapier@gentoo.org>
>>  L:  uclinux-dist-devel@blackfin.uclinux.org
>>  W:  http://blackfin.uclinux.org
>> @@ -1494,14 +1495,12 @@ S:   Supported
>>  F:  drivers/net/ethernet/adi/
>>
>>  BLACKFIN RTC DRIVER
>> -M:  Mike Frysinger <vapier.adi@gmail.com>
>>  L:  uclinux-dist-devel@blackfin.uclinux.org
>>  W:  http://blackfin.uclinux.org
>>  S:  Supported
>>  F:  drivers/rtc/rtc-bfin.c
>>
>>  BLACKFIN SDH DRIVER
>> -M:  Cliff Cai <cliff.cai@analog.com>
>>  L:  uclinux-dist-devel@blackfin.uclinux.org
>>  W:  http://blackfin.uclinux.org
>>  S:  Supported
>> @@ -1515,7 +1514,6 @@ S:     Supported
>>  F:  drivers/tty/serial/bfin_5xx.c
>>
>>  BLACKFIN WATCHDOG DRIVER
>> -M:  Mike Frysinger <vapier.adi@gmail.com>
>>  L:  uclinux-dist-devel@blackfin.uclinux.org
>>  W:  http://blackfin.uclinux.org
>>  S:  Supported
>
>Drivers or arches without specific people to maintain them
>really should not have "S: Supported".
>These should really be "S: Orphan".

The former maintainers quit ADI Linux team. Although no dedicated person is assigned this role, these drivers are still supported by the team under mailing list uclinux-dist-devel@blackfin.uclinux.org.


Thanks

Sonic Zhang
>
>
>
>

