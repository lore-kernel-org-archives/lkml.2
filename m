Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827Ab2EYKMA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 06:12:00 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:22703 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756196Ab2EYKL5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 06:11:57 -0400
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-SpamScore: -15
X-BigFish: VPS-15(zz9371I542M1432N98dKzz1202hzz8275bh8275dhz2dh2a8h668h839hd25hf0ah)
From: "Zhang, Sonic" <Sonic.Zhang@analog.com>
To: Shubhrajyoti Datta <omaplinuxkernel@gmail.com>
CC: Ben Dooks <ben-linux@fluff.org>, Wolfram Sang <w.sang@pengutronix.de>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>
Date: Fri, 25 May 2012 06:12:06 -0400
Subject: RE: [PATCH 8/8] i2c: i2c-bfin-twi: Move blackfin TWI register
 access Macro to head file.
Thread-Topic: [PATCH 8/8] i2c: i2c-bfin-twi: Move blackfin TWI register
 access Macro to head file.
Thread-Index: Ac06XqIYlbslm6SFROGX4h97TfiULAAABDDA
Message-ID: <DB904C5425BA6F4E8424B3B51A1414D170230E5AF6@NWD2CMBX1.ad.analog.com>
References: <1337152826-9850-1-git-send-email-sonic.zhang@analog.com>
	<1337152826-9850-8-git-send-email-sonic.zhang@analog.com>
	<CAM=Q2csSuQ3R9U=XKwj9F0xijTxx_ULperAiQYD_X3a5GKVjFg@mail.gmail.com>
	<DB904C5425BA6F4E8424B3B51A1414D170230E5ADF@NWD2CMBX1.ad.analog.com>
 <CAM=Q2cveBrYUiNYEbUgXyTnK2JhVD8UyhGgYJ=Zr86YnMMJ6Dg@mail.gmail.com>
In-Reply-To: <CAM=Q2cveBrYUiNYEbUgXyTnK2JhVD8UyhGgYJ=Zr86YnMMJ6Dg@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginatorOrg: analog.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: Shubhrajyoti Datta [mailto:omaplinuxkernel@gmail.com]
>Sent: Friday, May 25, 2012 6:10 PM
>To: Zhang, Sonic
>Cc: Ben Dooks; Wolfram Sang; linux-i2c@vger.kernel.org; LKML; uclinux-dist-
>devel@blackfin.uclinux.org
>Subject: Re: [PATCH 8/8] i2c: i2c-bfin-twi: Move blackfin TWI register access
>Macro to head file.
>
>Hi ,
>On Fri, May 25, 2012 at 3:24 PM, Zhang, Sonic <Sonic.Zhang@analog.com>
>wrote:
>>
>>
>>>-----Original Message-----
>>>From: Shubhrajyoti Datta [mailto:omaplinuxkernel@gmail.com]
>>>Sent: Friday, May 25, 2012 5:48 PM
>>>To: Zhang, Sonic
>>>Cc: Ben Dooks; Wolfram Sang; linux-i2c@vger.kernel.org; LKML; uclinux-dist-
>>>devel@blackfin.uclinux.org
>>>Subject: Re: [PATCH 8/8] i2c: i2c-bfin-twi: Move blackfin TWI register access
>>>Macro to head file.
>>>
>>>Hi ,
>>>Some minor comments/ doubts.
>>>On Wed, May 16, 2012 at 12:50 PM,  <sonic.zhang@analog.com> wrote:
>>>> From: Sonic Zhang <sonic.zhang@analog.com>
>>>>
>>>
>>>A small description may be helpful.
>>>Also the $SUBJECT says move the patch looks more like the remove.
>>>Am I missing something.
>>
>> The subject says these definitions are moved to a head file by the other patch
>for Blackfin architecture.
>
>Got it thanks.
>
>You may want to add a dependency otherwise it might lead to a compilation break?
>

That patch for Blackfin architecture has already been merged into mainline.

Regards,

Sonic

>
>>
>> Regards,
>>
>> Sonic


