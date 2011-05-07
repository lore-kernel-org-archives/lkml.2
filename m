Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920Ab1EGR7g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 13:59:36 -0400
Received: from relay1.ukrpost.ua ([82.207.79.21]:52765 "EHLO relay1.ukrpost.ua"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752865Ab1EGR7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 13:59:35 -0400
X-Greylist: delayed 387 seconds by postgrey-1.27 at vger.kernel.org; Sat, 07 May 2011 13:59:34 EDT
X-Spam-Processed: mail.academy.zt.ua, Sat, 07 May 2011 20:51:49 +0300
	(not processed: message from trusted or authenticated source)
X-Authenticated-Sender: george@academy.zt.ua
X-HashCash: 1:20:110507:md50000002737::z3HuxJyYenF5G0LO:00005Wt/
X-Return-Path: prvs=110837b279=george@znau.edu.ua
X-Envelope-From: george@znau.edu.ua
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH][WAS:bcmai,axi] bcma: add Broadcom specific AMBA bus
	driver
From: George Kashperko <george@znau.edu.ua>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        b43-dev@lists.infradead.org, Greg KH <greg@kroah.com>,
        Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Arend van Spriel <arend@broadcom.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <rmk@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Andy Botting <andy@andybotting.com>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4DC5805C.2010202@hauke-m.de>
References: <1304632783-8781-1-git-send-email-zajec5@gmail.com>
	 <4DC56FB9.5000208@hauke-m.de>
	 <BANLkTi=FfjK7obq0hj4TjYZc-GgzTuUC6g@mail.gmail.com>
	 <4DC57425.30206@hauke-m.de>
	 <BANLkTikTarvigU-xZNZikhLyvUWse448Tg@mail.gmail.com>
	 <4DC5805C.2010202@hauke-m.de>
Content-Type: text/plain
Date: Sat, 07 May 2011 20:45:24 +0300
Message-Id: <1304790324.13983.5.camel@dev.znau.edu.ua>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-19.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Some of the embedded devices also have a USB core on the BCMA bus and a
> pci(e) host controller to connect other pci(e) devices. As most of the
> patches for ssb came from the wireless guys and I do not thing this will
> be different for bcma, I thing the wireless mailing list is the correct
> place.
> 
> @George what is the status of adding support for the embedded devices?
Haven't been looking into Rafal's code closely yet. I'm working on
another solution suitable for SSB, AXI and hopefully UBUS as well but I
don't ready to publish it yet.

Regarding ethernet driver, still no feedback on GPL-friendly licensing
possibility for the code from Broadcom.

Have nice day,
George


