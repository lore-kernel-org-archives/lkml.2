Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611Ab1DJOga (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 10:36:30 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:3837 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752244Ab1DJOg3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 10:36:29 -0400
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
cc: "Pavel Machek" <pavel@ucw.cz>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        "Michael B?sch" <mb@bu3sch.de>,
        "Larry Finger" <Larry.Finger@lwfinger.net>,
        "George Kashperko" <george@znau.edu.ua>,
        "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Russell King" <rmk@arm.linux.org.uk>, "Arnd Bergmann" <arnd@arndb.de>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] bcmai: introduce AI driver
References: <1302033463-1846-1-git-send-email-zajec5@gmail.com>
 <op.vtisojsk3ri7v4@arend-laptop> <20110410080159.GB2798@ucw.cz>
 <BANLkTikL+GvaKN6nT-9WjpPjaJz0dR51KQ@mail.gmail.com>
 <20110410082420.GA1460@localhost.ucw.cz>
 <BANLkTim9JTpZGib+_C_vTFFhP5azbGwMjg@mail.gmail.com>
 <op.vtpt6v173ri7v4@arend-laptop>
 <BANLkTimgJ--19=q-od7S8uj6T6AcXrtg7w@mail.gmail.com>
Date: Sun, 10 Apr 2011 16:36:10 +0200
MIME-Version: 1.0
From: "Arend van Spriel" <arend@broadcom.com>
Organization: Broadcom
Message-ID: <op.vtp76iua3ri7v4@arend-laptop>
In-Reply-To: <BANLkTimgJ--19=q-od7S8uj6T6AcXrtg7w@mail.gmail.com>
User-Agent: Opera Mail/11.01 (Linux)
X-WSS-ID: 61BF1E993CK13659876-01-01
Content-Type: text/plain;
 charset=utf-8;
 format=flowed;
 delsp=yes
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Apr 2011 13:32:43 +0200, Rafał Miłecki <zajec5@gmail.com> wrote:

> W dniu 10 kwietnia 2011 11:33 użytkownik Arend van Spriel
> <arend@broadcom.com> napisał:
>> On Sun, 10 Apr 2011 10:30:53 +0200, Rafał Miłecki <zajec5@gmail.com>  
>> wrote:
>>
>>> 2011/4/10 Pavel Machek <pavel@ucw.cz>:
>>>>>
>>>>> >> >+config BCMAI_HOST_PCI_POSSIBLE
>>>>> >> >+       bool
>>>>> >> >+       depends on BCMAI && PCI = y
>>>>> >> >+       default y
>>>>> >> >+
>>>>> >> >+config BCMAI_HOST_PCI
>>>>> >> >+       bool "Support for AI on PCI-host bus"
>>>>> >> >+       depends on BCMAI_HOST_PCI_POSSIBLE
>>>>> >> >+
>>
>> Hi Rafał,
>>
>> Could use term AMBA AXI instead which gives enough hits on Google to  
>> hint
>> interested people to more in depth information.
>>
>> FYI: AXI = Advanced eXtensible Interface
>>        High-speed interconnect for chip cores ( provides higher
>> bursts/transfers than predecessor AHB = Advanced High-performance Bus
>> (AHB)).
>
> "If you check PATCH V2, we renamed this to (AMBA) AXI"
>

Geez, I totally missed Pavel was commenting on the first patch. Sorry,  
Rafał.

Gr. AvS
-- 
"The world is indeed comic, but the joke is on mankind." — H.P. Lovecraft

