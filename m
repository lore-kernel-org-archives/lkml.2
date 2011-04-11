Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742Ab1DKVTQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 17:19:16 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:52181 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754795Ab1DKVTP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 17:19:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CeBelk4IXHbC7B/vJZtibL+SuqnVk3FP3apG/d981ZQH2AEqYRK+oIsGvLt2gq2+M0
         n4V7Ps0SsEj4Wbk7FTDaf1p4ljknRDEROjajRmapleMrcGs95r4JbhH/BFh9VSCjgAtf
         L5iUu/6cJrkyxmI9jsjuRUbOdtJJTYXc8lBAI=
MIME-Version: 1.0
In-Reply-To: <20110411210631.GA28559@kroah.com>
References: <1302557114-7880-1-git-send-email-zajec5@gmail.com>
	<20110411210631.GA28559@kroah.com>
Date: Mon, 11 Apr 2011 23:19:13 +0200
Message-ID: <BANLkTim155YxMUVJ=pmVs-rNhkovGPG6OQ@mail.gmail.com>
Subject: Re: [RFC][PATCH V3] axi: add AXI bus driver
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        George Kashperko <george@znau.edu.ua>, Arnd Bergmann <arnd@arndb.de>,
        Russell King <rmk@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        b43-dev@lists.infradead.org,
        =?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        Andy Botting <andy@andybotting.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/11 Greg KH <greg@kroah.com>:
> On Mon, Apr 11, 2011 at 11:25:14PM +0200, Rafał Miłecki wrote:
>> +static void axi_release_core_dev(struct device *dev)
>> +{
>> +     /* Silent lack-of-release warning */
>> +}
>
> Ok, WTF!!!!

Thank you for your kindly words. It's much more enjoyable to work on
kernel that way. I definitely made that on purpose.

-- 
Rafał
