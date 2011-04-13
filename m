Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933076Ab1DMVf3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 17:35:29 -0400
Received: from mail.academy.zt.ua ([82.207.120.245]:63401 "EHLO
	mail.academy.zt.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932855Ab1DMVf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 17:35:27 -0400
X-MDAV-Processed: mail.academy.zt.ua, Thu, 14 Apr 2011 00:27:24 +0300
X-Spam-Processed: mail.academy.zt.ua, Thu, 14 Apr 2011 00:27:23 +0300
	(not processed: message from trusted or authenticated source)
X-Authenticated-Sender: george@academy.zt.ua
X-Return-Path: george@znau.edu.ua
X-Envelope-From: george@znau.edu.ua
Subject: Re: [RFC][PATCH V4] axi: add AXI bus driver
From: George Kashperko <george@znau.edu.ua>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: Greg KH <greg@kroah.com>, linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        b43-dev@lists.infradead.org,
        Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Arend van Spriel <arend@broadcom.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <rmk@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Andy Botting <andy@andybotting.com>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <BANLkTinLn4Ug=gX4coHJbSzrkxdSMjgGeg@mail.gmail.com>
References: <1302634375-2378-1-git-send-email-zajec5@gmail.com>
	 <20110413163113.GA24015@kroah.com>
	 <BANLkTin-4HrJzNrLOxRy_-a98S3ZF4aSQw@mail.gmail.com>
	 <1302726703.8015.1.camel@dev.znau.edu.ua>
	 <BANLkTimwZOJ0a5kVfaUzEcsMc39H999u0A@mail.gmail.com>
	 <1302727516.8015.9.camel@dev.znau.edu.ua>
	 <BANLkTi=wzzzeF-PmqLt9o8arW7nRaFRRJw@mail.gmail.com>
	 <1302729243.8479.1.camel@dev.znau.edu.ua>
	 <BANLkTinLn4Ug=gX4coHJbSzrkxdSMjgGeg@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 14 Apr 2011 00:24:10 +0300
Message-Id: <1302729850.8479.7.camel@dev.znau.edu.ua>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-19.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 2011/4/13 George Kashperko <george@znau.edu.ua>:
> >> I had no idea what you were referring to. We do not dig into PCIe
> >> functions yet, so I believe for now we need this "if".
> > You are already deep inside. Your host code drives pci function.
> 
> But I don't use multiple PCIe functions, do not focus on that at all.
> 
Don't see anything in the host driver code preventing it to be bound to
functions other than 0. But anyways if you sure your host will be used
by several cores then why don't you spinlock window accesses ?

Have nice day,
George


