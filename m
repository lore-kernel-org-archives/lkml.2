Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757707Ab2IUTU2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 15:20:28 -0400
Received: from cust-218-222.on4.ontelecoms.gr ([92.118.218.222]:53879 "EHLO
	vergina.dyndns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755906Ab2IUTU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 15:20:27 -0400
Message-ID: <505CBDF9.9020503@asyr.hopto.org>
Date: Fri, 21 Sep 2012 22:20:25 +0300
From: Thanasis <thanasis@asyr.hopto.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120913 Thunderbird/15.0.1
MIME-Version: 1.0
To: Francois Romieu <romieu@fr.zoreil.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: Re: RTL8101E/RTL8102E PCI Express Fast Ethernet controller (rev 02)
References: <505B522F.9090808@asyr.hopto.org> <CAErSpo4ydsZzrQJCO73mvTEn8TBDVRxg2D0UaHY0XgdyPxJaLQ@mail.gmail.com> <505B5C11.1050503@asyr.hopto.org> <CAErSpo6W0zy+HkRWW9bE=Ma--9vwgjrOWin8d5QNvUJWQtwM0w@mail.gmail.com> <20120920232030.GA9224@electric-eye.fr.zoreil.com> <505BF437.4090506@asyr.hopto.org> <20120921152828.GA24364@electric-eye.fr.zoreil.com> <505C98C7.20302@asyr.hopto.org> <20120921175455.GA28255@electric-eye.fr.zoreil.com>
In-Reply-To: <20120921175455.GA28255@electric-eye.fr.zoreil.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So far, ping has failed *only* at this iteration of the make loop:

HEAD is now at b087148 r8169: support control of advertising.
make -C /lib/modules/2.6.38-r8/build
M=/mnt/usb-disk/atom/usr/src/test-r8169/r8169 modules
make[1]: Entering directory `/usr/src/linux-2.6.38-r8'
  CC [M]  /mnt/usb-disk/atom/usr/src/test-r8169/r8169/r8169.o
  Building modules, stage 2.
  MODPOST 1 modules
  CC      /mnt/usb-disk/atom/usr/src/test-r8169/r8169/r8169.mod.o
  LD [M]  /mnt/usb-disk/atom/usr/src/test-r8169/r8169/r8169.ko
make[1]: Leaving directory `/usr/src/linux-2.6.38-r8'
PING 192.168.0.1 (192.168.0.1) 56(84) bytes of data.
>From 192.168.0.19: icmp_seq=1 Destination Host Unreachable
>From 192.168.0.19: icmp_seq=2 Destination Host Unreachable
>From 192.168.0.19: icmp_seq=3 Destination Host Unreachable

--- 192.168.0.1 ping statistics ---
3 packets transmitted, 0 received, +3 errors, 100% packet loss, time 1999ms
pipe 3


Now, after 74 iterations, it looks as if the loop is stuck at the following:

HEAD is now at 1ce4b16 r8169: spinlock redux.
make -C /lib/modules/2.6.38-r8/build
M=/mnt/usb-disk/atom/usr/src/test-r8169/r8169 modules
make[1]: Entering directory `/usr/src/linux-2.6.38-r8'
  CC [M]  /mnt/usb-disk/atom/usr/src/test-r8169/r8169/r8169.o
  Building modules, stage 2.
  MODPOST 1 modules
  CC      /mnt/usb-disk/atom/usr/src/test-r8169/r8169/r8169.mod.o
  LD [M]  /mnt/usb-disk/atom/usr/src/test-r8169/r8169/r8169.ko
make[1]: Leaving directory `/usr/src/linux-2.6.38-r8'


Should I wait for it to end?
Do you want me to post the whole log so far?

