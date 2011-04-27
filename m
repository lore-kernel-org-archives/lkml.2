Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110Ab1D0K54 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 06:57:56 -0400
Received: from mail001.aei.ca ([206.123.6.130]:47798 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756063Ab1D0K5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 06:57:55 -0400
From: Ed Tomlinson <edt@aei.ca>
To: "Gustavo F. Padovan" <padovan@profusion.mobi>
Subject: Re: [BUG] bluetooth doesn't work from 2.6.39-rc1+ to 2.6.39-rc3+
Date: Wed, 27 Apr 2011 06:57:49 -0400
User-Agent: KMail/1.13.7 (Linux/2.6.38.4-crc+; KDE/4.6.2; x86_64; ; )
Cc: Hui Zhu <teawater@gmail.com>, Dave Young <hidave.darkstar@gmail.com>,
        linux-kernel@vger.kernel.org,
        Bluettooth Linux <linux-bluetooth@vger.kernel.org>
References: <BANLkTi=Ei91GRcL2oP0G16LDy7mpLoDEGQ@mail.gmail.com> <201104240952.14848.edt@aei.ca> <20110426161330.GC2242@joana>
In-Reply-To: <20110426161330.GC2242@joana>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104270657.49646.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 April 2011 12:13:30 Gustavo F. Padovan wrote:
> * Ed Tomlinson <edt@aei.ca> [2011-04-24 09:52:14 -0400]:
> 
> > On Tuesday 19 April 2011 11:34:30 Hui Zhu wrote:
> > > Do you part is OK?
> > > 
> > > I think it will be very easy to reproduce.
> > > 
> > > Thanks,
> > > Hui
> > > 
> > > On Tue, Apr 19, 2011 at 15:46, Dave Young <hidave.darkstar@gmail.com> wrote:
> > > > On Tue, Apr 19, 2011 at 10:53 AM, Hui Zhu <teawater@gmail.com> wrote:
> > > >> Cannot connect to any outside devices through bluetooth.
> > > >>
> > > >> And I think this is not a bug of low level driver.  Because both my
> > > >> laptop and a usb bluetooth card cannot work.
> > > >
> > > > Hi, please explain the "cannot work" in detail,
> > > > Firstly check dmesg and hciconfig to see if there's anything wrong.
> > 
> > I am also seeing problems with bluetooth in .39-rc4+
> > 
> > [54511.033258] usb 2-4.4: USB disconnect, device number 5
> > [54513.920060] usb 2-4.3: new full speed USB device number 6 using ehci_hcd
> > [54514.063057] usb 2-4.3: New USB device found, idVendor=0a12, idProduct=0001
> > [54514.070281] usb 2-4.3: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> > grover ~ # hciconfig -a
> > hci0:   Type: BR/EDR  Bus: USB
> >         BD Address: 00:0A:3A:55:07:5A  ACL MTU: 192:8  SCO MTU: 64:8
> >         DOWN 
> >         RX bytes:718 acl:0 sco:0 events:25 errors:0
> >         TX bytes:108 acl:0 sco:0 commands:24 errors:0
> >         Features: 0xff 0xff 0x0f 0x00 0x00 0x00 0x00 0x00
> >         Packet type: DM1 DM3 DM5 DH1 DH3 DH5 HV1 HV2 HV3 
> >         Link policy: CONFIG_BT_HCIBTUSB=m
> >         Link mode: SLAVE ACCEPT 
> > 
> > grover ~ # hciconfig hci0 up
> > Can't init device hci0: Invalid argument (22)
> 
> does dmesg show something? I'm using a -rc kernel and bluetooth is working to
> me.

What dmesg shows is included above.  The tell tail for this bug is the error 22 from
user space.  I see nothing on the kernel side.

Ed
