Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382Ab1DMIQ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 04:16:57 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:3815 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753885Ab1DMIQw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 04:16:52 -0400
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
To: "George Kashperko" <george@znau.edu.ua>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
cc: "balbi@ti.com" <balbi@ti.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
        =?utf-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
        "Larry Finger" <Larry.Finger@lwfinger.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Russell King" <rmk@arm.linux.org.uk>, "Arnd Bergmann" <arnd@arndb.de>,
        "Andy Botting" <andy@andybotting.com>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] axi: add AXI bus driver
References: <1302566227-23788-1-git-send-email-zajec5@gmail.com>
 <20110412133633.GR15130@legolas.emea.dhcp.ti.com>
 <1302634039.14216.10.camel@dev.znau.edu.ua>
 <BANLkTi=0sM2+nPYyd09G=Uy9rcEvaFErnA@mail.gmail.com>
 <1302635550.14216.21.camel@dev.znau.edu.ua>
 <BANLkTi=8mB9ZDTjF4yds6mkx+PmM+B_6Cg@mail.gmail.com>
 <4DA4AC4B.90409@hauke-m.de>
 <BANLkTiknRYWaDM1ThAxgXcdGqK8jeFaBPA@mail.gmail.com>
 <BANLkTikqKtJuDS17mfFvxzMoXuBtJvCgTA@mail.gmail.com>
 <1302640546.14216.65.camel@dev.znau.edu.ua>
 <BANLkTim8dmTL-BVK3fcWHNBU9Eyz1k_T+Q@mail.gmail.com>
Date: Wed, 13 Apr 2011 10:16:37 +0200
MIME-Version: 1.0
From: "Arend van Spriel" <arend@broadcom.com>
Organization: Broadcom
Message-ID: <op.vtvalzu33ri7v4@arend-laptop>
In-Reply-To: <BANLkTim8dmTL-BVK3fcWHNBU9Eyz1k_T+Q@mail.gmail.com>
User-Agent: Opera Mail/11.10 (Linux)
X-WSS-ID: 61BB83163I810647455-01-01
Content-Type: text/plain;
 charset=utf-8;
 format=flowed;
 delsp=yes
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Apr 2011 22:44:01 +0200, Rafał Miłecki <zajec5@gmail.com> wrote:

> 2011/4/12 George Kashperko <george@znau.edu.ua>:
>>> 2011/4/12 Rafał Miłecki <zajec5@gmail.com>:
>>> That way I see really low (or not at all) relation between out
>>> (not)Broadcom bus and present AMBA bus.
>>>
>> Agree.
>
> Ehh, sounds like one more renaming to functions, defines, prefixes.
>
> Let's wait for Arend comments, he was the one voting for  
> not-bcm-specific name.
>

Hi Rafał,

Still think its better to stick with a generic name even if currently you  
only come across this in Broadcom chips right now. I do agree that the  
term 'axi' is implying something else than what this bus driver is  
providing. The name 'axi-dmp' I gave earlier may be more to the point.

I also looked at the amba driver after receiving comments on the brcmaxi  
library module (this is what Hauke Mehrtens referred to) and came to  
similar conclusion as you did. It does however support PM properly so you  
may want to get inspiration in that area. I also noticed a reference to  
AMBA term APB which is a different bus in the AMBA family. AXI was  
introduced later as higher performance bus (in AMBA rev3 if I remember  
correctly).

Gr. AvS
-- 
"The world is indeed comic, but the joke is on mankind." — H.P. Lovecraft

