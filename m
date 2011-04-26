Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434Ab1DZQNW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 12:13:22 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:59552 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755189Ab1DZQNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 12:13:17 -0400
Date: Tue, 26 Apr 2011 13:13:30 -0300
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: Ed Tomlinson <edt@aei.ca>
Cc: Hui Zhu <teawater@gmail.com>, Dave Young <hidave.darkstar@gmail.com>,
        linux-kernel@vger.kernel.org,
        Bluettooth Linux <linux-bluetooth@vger.kernel.org>
Subject: Re: [BUG] bluetooth doesn't work from 2.6.39-rc1+ to 2.6.39-rc3+
Message-ID: <20110426161330.GC2242@joana>
Mail-Followup-To: Ed Tomlinson <edt@aei.ca>, Hui Zhu <teawater@gmail.com>,
	Dave Young <hidave.darkstar@gmail.com>,
	linux-kernel@vger.kernel.org,
	Bluettooth Linux <linux-bluetooth@vger.kernel.org>
References: <BANLkTi=Ei91GRcL2oP0G16LDy7mpLoDEGQ@mail.gmail.com>
 <BANLkTi=-RnUyuC2VGuRix_J4KOx+9BhroQ@mail.gmail.com>
 <BANLkTik67uGB-1q17JcTPnr_WjuNd_37gA@mail.gmail.com>
 <201104240952.14848.edt@aei.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201104240952.14848.edt@aei.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ed Tomlinson <edt@aei.ca> [2011-04-24 09:52:14 -0400]:

> On Tuesday 19 April 2011 11:34:30 Hui Zhu wrote:
> > Do you part is OK?
> > 
> > I think it will be very easy to reproduce.
> > 
> > Thanks,
> > Hui
> > 
> > On Tue, Apr 19, 2011 at 15:46, Dave Young <hidave.darkstar@gmail.com> wrote:
> > > On Tue, Apr 19, 2011 at 10:53 AM, Hui Zhu <teawater@gmail.com> wrote:
> > >> Cannot connect to any outside devices through bluetooth.
> > >>
> > >> And I think this is not a bug of low level driver.  Because both my
> > >> laptop and a usb bluetooth card cannot work.
> > >
> > > Hi, please explain the "cannot work" in detail,
> > > Firstly check dmesg and hciconfig to see if there's anything wrong.
> 
> I am also seeing problems with bluetooth in .39-rc4+
> 
> [54511.033258] usb 2-4.4: USB disconnect, device number 5
> [54513.920060] usb 2-4.3: new full speed USB device number 6 using ehci_hcd
> [54514.063057] usb 2-4.3: New USB device found, idVendor=0a12, idProduct=0001
> [54514.070281] usb 2-4.3: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> grover ~ # hciconfig -a
> hci0:   Type: BR/EDR  Bus: USB
>         BD Address: 00:0A:3A:55:07:5A  ACL MTU: 192:8  SCO MTU: 64:8
>         DOWN 
>         RX bytes:718 acl:0 sco:0 events:25 errors:0
>         TX bytes:108 acl:0 sco:0 commands:24 errors:0
>         Features: 0xff 0xff 0x0f 0x00 0x00 0x00 0x00 0x00
>         Packet type: DM1 DM3 DM5 DH1 DH3 DH5 HV1 HV2 HV3 
>         Link policy: CONFIG_BT_HCIBTUSB=m
>         Link mode: SLAVE ACCEPT 
> 
> grover ~ # hciconfig hci0 up
> Can't init device hci0: Invalid argument (22)

does dmesg show something? I'm using a -rc kernel and bluetooth is working to
me.

-- 
Gustavo F. Padovan
http://profusion.mobi
