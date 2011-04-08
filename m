Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943Ab1DHXqc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 19:46:32 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:42263 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440Ab1DHXqa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 19:46:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=o4YTwTrm7tUd3KqldcSiLTve1dseEiQnSyvwka8kEhGZ3mFoNFDXe9YU2g/HRQ8xcb
         u89rIk4vj1inHPZ+PNofa5GwqNufORzkCmq7RmmHX5fj28Khb2Ih+qL+M6hiFc9CZ4WF
         AtHMAOjVHAUAuuW3uqK7djfQDHQj1MG7klKvg=
MIME-Version: 1.0
In-Reply-To: <20110408220157.GC26019@kroah.com>
References: <1302291900-1902-1-git-send-email-zajec5@gmail.com>
	<20110408220157.GC26019@kroah.com>
Date: Sat, 9 Apr 2011 01:46:29 +0200
Message-ID: <BANLkTin_-hhcexTd67HviTqM4bjXMZxweA@mail.gmail.com>
Subject: Re: [RFC][WAS:bcmai][PATCH V2] axi: add AXI bus driver
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
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/9 Greg KH <greg@kroah.com>:
>> +static void axi_release_core_dev(struct device *dev)
>> +{
>> +     kfree(dev);
>> +}
>
> This is wrong, unless you are really only creating a 'struct device'.
> Why are you doing that instead of embedding struct device in your
> structure?

Hm, I think Greg found explanation why we can not reload axi driver
successfully :)

I'll take care of your comment after weekend, thank you everybody.

-- 
Rafał
