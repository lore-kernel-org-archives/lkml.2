Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab1EHInp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 04:43:45 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:4691 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361Ab1EHInn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 04:43:43 -0400
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
Message-ID: <4DC657A4.7020800@broadcom.com>
Date: Sun, 8 May 2011 10:43:16 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17)
 Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
cc: "George Kashperko" <george@znau.edu.ua>, "Arnd Bergmann" <arnd@arndb.de>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
        "Greg KH" <greg@kroah.com>,
        =?UTF-8?B?TWljaGFlbCBCw7xzY2g=?= <mb@bu3sch.de>,
        "Larry Finger" <Larry.Finger@lwfinger.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Russell King" <rmk@arm.linux.org.uk>,
        "Andy Botting" <andy@andybotting.com>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][WAS:bcmai,axi] bcma: add Broadcom specific AMBA bus
 driver
References: <1304632783-8781-1-git-send-email-zajec5@gmail.com>
 <201105061605.31625.arnd@arndb.de>
 <BANLkTikjr0ZTNOu69F+iKhwufE9KKMg4Tg@mail.gmail.com>
 <BANLkTimGBNT4FkS4mO9ToLWft0bCEYcEgg@mail.gmail.com>
 <1304790665.13983.10.camel@dev.znau.edu.ua>
 <BANLkTikLFff_86Fvg+jSty9vGLENiELF2Q@mail.gmail.com>
 <1304792795.13983.28.camel@dev.znau.edu.ua>
 <BANLkTi=6BFD4OmtU1WPxjbFJQe36=mZKEA@mail.gmail.com>
In-Reply-To: <BANLkTi=6BFD4OmtU1WPxjbFJQe36=mZKEA@mail.gmail.com>
X-WSS-ID: 61D887F24NS3279446-01-01
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2011 08:48 PM, Rafał Miłecki wrote:
> 2011/5/7 George Kashperko<george@znau.edu.ua>:
>> I guess core id 0x800 by 0x04BF vendor and 0x800 by 0x043B vendor will
>> both be reported as ChipCommon which most likely is wrong for second
>> one. Btw, ChipCommon is 0x500 for 4706 and there will be more new core
>> codes for new Broadcom devices. Don't think its right to build core
>> names database into kernel while there will be at most few of them used
>> on particular end system.
> This is constructive, I'll fix this, thanks.

Hi Rafał,

Late response, but I tried to tell what George clarified by the example 
above so you need nested switch.

I tend to agree with George that having this id to name conversion in 
the bus driver may be nice for debugging, but apart from memory usage it 
also gives you additional maintenance work. Leave it up to you.

Gr. AvS

