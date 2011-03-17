Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab1CQBLl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 21:11:41 -0400
Received: from novprvlin0050.provo.novell.com ([137.65.248.33]:45648 "EHLO
	novprvlin0050.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755829Ab1CQBLe (ORCPT
	<rfc822;groupwise-jlee@novell.com:2:1>);
	Wed, 16 Mar 2011 21:11:34 -0400
Message-Id: <4D81FA730200002300029F0F@novprvlin0050.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 
Date: Wed, 16 Mar 2011 19:11:31 -0600
From: "Joey Lee" <jlee@novell.com>
To: <mihai.dontu@gmail.com>
Cc: <zajec5@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <platform-driver-x86@vger.kernel.org>
Subject: Re: [b43] usb device disconnects automatically after 1s
References: <201103170018.32061.mihai.dontu@gmail.com>
 <201103170022.24290.mihai.dontu@gmail.com>
 <AANLkTi=-B0e4VT_v+F23Q+hG_zn=JnVbmVHnFpETVrZu@mail.gmail.com>
 <201103170106.58746.mihai.dontu@gmail.com>
In-Reply-To: <201103170106.58746.mihai.dontu@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Cc. to platform driver guys.

於 四，2011-03-17 於 01:06 +0200，Mihai Donțu 提到：
> On Thursday 17 March 2011 00:35:02 Rafał Miłecki wrote:
> > 2011/3/16 Mihai Donțu <mihai.dontu@gmail.com>:
> > > Added linux-usb and linux-wireless to CC.
> > > 
> > > On Thursday 17 March 2011 00:18:31 Mihai Donțu wrote:
> > >> Hi,
> > >> 
> > >> I have just upgraded to 2.6.38 and discovered that I can't use my
> > >> wireless device (BCM4312 802.11a/b/g). I press Fn + F2, the bluetooth
> > >> led lights and after a second it turns off by itself. In dmesg I'm
> > >> seeing the following:
> > >> 
> > >> [   88.167212] usb 1-2.2: new full speed USB device using ehci_hcd and
> > >> address 5
> > >> [   88.782330] usb 1-2.2: USB disconnect, address 5
> > >> 
> > >> I switched to 2.6.37 until I'll have some time to bisect this. In the
> > >> mean time I have attached the output of lspci, interrupts and dmesg.
> > 
> > I suspect it's WMI related. What is your machine?
> 
> It's a Dell Latitude D520 but I can't find a link with full specs (in 
> English).
> 
> > Please check:
> > https://bugzilla.kernel.org/show_bug.cgi?id=31002
> > http://comments.gmane.org/gmane.linux.acpi.devel/49577
> > 
> > I can't help you more, I just noticed such a issue reported on ACPI
> > ML, you have to dig into this yourself (or someone else may help you).
> 
> Thanks for the links. I'll see if I can get anywhere from there.
> 


