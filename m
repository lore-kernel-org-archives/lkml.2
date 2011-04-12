Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384Ab1DLUoF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 16:44:05 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:46370 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757263Ab1DLUoC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 16:44:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CtQ6FqSDmX0sHJJfJS4mQtfeAbHhZ8tEHi43Dj660KviwoyRqzdQ5vJK8Ahq4TwAtw
         b8xzNsqH7P124/AnEnlsujXiek9xtKIQDRQRZdIxWnw2jYjWm7O5HGBUIi44JqFwRUUC
         tnGs29JEHcUjwE6aOHm9C9yS2Dqy6OCDWOcoM=
MIME-Version: 1.0
In-Reply-To: <1302640546.14216.65.camel@dev.znau.edu.ua>
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
Date: Tue, 12 Apr 2011 22:44:01 +0200
Message-ID: <BANLkTim8dmTL-BVK3fcWHNBU9Eyz1k_T+Q@mail.gmail.com>
Subject: Re: [RFC][PATCH] axi: add AXI bus driver
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: George Kashperko <george@znau.edu.ua>
Cc: balbi@ti.com, linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        b43-dev@lists.infradead.org,
        =?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Arend van Spriel <arend@broadcom.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <rmk@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Andy Botting <andy@andybotting.com>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/12 George Kashperko <george@znau.edu.ua>:
>> 2011/4/12 Rafał Miłecki <zajec5@gmail.com>:
>> That way I see really low (or not at all) relation between out
>> (not)Broadcom bus and present AMBA bus.
>>
> Agree.

Ehh, sounds like one more renaming to functions, defines, prefixes.

Let's wait for Arend comments, he was the one voting for not-bcm-specific name.

-- 
Rafał
