Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932569Ab1DMVTv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 17:19:51 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:58319 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab1DMVTu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 17:19:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NzLyOdLdqSRDYOrj9wsYCDOCbr4uHtISfa837TQVqlw0Q5iKfiKlAWbFAyA/bX4hJQ
         9Im0T2EcA6Du+AlrYxiNzzfxu42qOjwf0AJNgB2FMkO3z95VXdQfr046UjBhWMAhx51R
         pmrs/5I2ssv5Pbb+q4WAelqi13B7jvG1G7xs8=
MIME-Version: 1.0
In-Reply-To: <1302729243.8479.1.camel@dev.znau.edu.ua>
References: <1302634375-2378-1-git-send-email-zajec5@gmail.com>
	<20110413163113.GA24015@kroah.com>
	<BANLkTin-4HrJzNrLOxRy_-a98S3ZF4aSQw@mail.gmail.com>
	<1302726703.8015.1.camel@dev.znau.edu.ua>
	<BANLkTimwZOJ0a5kVfaUzEcsMc39H999u0A@mail.gmail.com>
	<1302727516.8015.9.camel@dev.znau.edu.ua>
	<BANLkTi=wzzzeF-PmqLt9o8arW7nRaFRRJw@mail.gmail.com>
	<1302729243.8479.1.camel@dev.znau.edu.ua>
Date: Wed, 13 Apr 2011 23:19:48 +0200
Message-ID: <BANLkTinLn4Ug=gX4coHJbSzrkxdSMjgGeg@mail.gmail.com>
Subject: Re: [RFC][PATCH V4] axi: add AXI bus driver
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: George Kashperko <george@znau.edu.ua>
Cc: Greg KH <greg@kroah.com>, linux-wireless@vger.kernel.org,
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

2011/4/13 George Kashperko <george@znau.edu.ua>:
>> I had no idea what you were referring to. We do not dig into PCIe
>> functions yet, so I believe for now we need this "if".
> You are already deep inside. Your host code drives pci function.

But I don't use multiple PCIe functions, do not focus on that at all.

-- 
Rafał
