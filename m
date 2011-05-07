Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336Ab1EGQte (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 12:49:34 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:46429 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752Ab1EGQtc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 12:49:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GCWybaqH8IsT9TgSOkjvxPeRcslWOYG6qM0/6LCrhu4K+oehAU6C2zauYOQjQsZ4Ns
         6aKA52jhjgHGFLvpoSLmNczoq7GlD9JWlE9peHZVd8NfjEyzyZfXNb/SDlEvvnFVDkxv
         igy6RkO4kcQYjIfGHnF+rX39CCUUbmFpZI5ZI=
MIME-Version: 1.0
In-Reply-To: <4DC57383.3050903@broadcom.com>
References: <1304632783-8781-1-git-send-email-zajec5@gmail.com>
	<201105061605.31625.arnd@arndb.de>
	<BANLkTikjr0ZTNOu69F+iKhwufE9KKMg4Tg@mail.gmail.com>
	<BANLkTimGBNT4FkS4mO9ToLWft0bCEYcEgg@mail.gmail.com>
	<1304776555.16344.2.camel@maggie>
	<4DC57383.3050903@broadcom.com>
Date: Sat, 7 May 2011 18:49:30 +0200
Message-ID: <BANLkTi=GJs=04H=HpCDy_o1JnhY4+aPgxA@mail.gmail.com>
Subject: Re: [PATCH][WAS:bcmai,axi] bcma: add Broadcom specific AMBA bus driver
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: =?UTF-8?Q?Michael_B=C3=BCsch?= <m@bues.ch>, Arnd Bergmann <arnd@arndb.de>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
        Greg KH <greg@kroah.com>,
        =?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        George Kashperko <george@znau.edu.ua>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <rmk@arm.linux.org.uk>,
        Andy Botting <andy@andybotting.com>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/7 Arend van Spriel <arend@broadcom.com>:
> On 05/07/2011 03:55 PM, Michael Büsch wrote:
>>
>>> Arnd: did you have a look at defines at all?
>>>
>>> Most of the defines have values in range 0x800 → 0x837. Converting
>>> this to array means loosing 0x800 u16 entries. We can not use 0x800
>>> offset, because there are also some defined between 0x000 and 0x800:
>>> #define BCMA_CORE_OOB_ROUTER           0x367   /* Out of band */
>>> #define BCMA_CORE_INVALID              0x700
>
> Please be aware that the core identifier itself is not unique (in the
> current list they are). In the scan the BCMA_CORE_OOB_ROUTER will always
> show BCMA_MANUF_ARM (did not look up the proper manufacturer define but you
> get the idea, i hope).

Unfortunately, I don't. Could you explain this? How core identified
can be not unique? Can 0x800 mean ChipCommon but also SuperPCIeX?

-- 
Rafał
