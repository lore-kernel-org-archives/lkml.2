Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200Ab2IYNFx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 09:05:53 -0400
Received: from cust-218-222.on4.ontelecoms.gr ([92.118.218.222]:54264 "EHLO
	vergina.dyndns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810Ab2IYNFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 09:05:51 -0400
Message-ID: <5061AC2D.6030407@asyr.hopto.org>
Date: Tue, 25 Sep 2012 16:05:49 +0300
From: Thanasis <thanasis@asyr.hopto.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120913 Thunderbird/15.0.1
MIME-Version: 1.0
To: Francois Romieu <romieu@fr.zoreil.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: Re: RTL8101E/RTL8102E PCI Express Fast Ethernet controller (rev 02)
References: <CAErSpo4ydsZzrQJCO73mvTEn8TBDVRxg2D0UaHY0XgdyPxJaLQ@mail.gmail.com> <505B5C11.1050503@asyr.hopto.org> <CAErSpo6W0zy+HkRWW9bE=Ma--9vwgjrOWin8d5QNvUJWQtwM0w@mail.gmail.com> <20120920232030.GA9224@electric-eye.fr.zoreil.com> <505BF437.4090506@asyr.hopto.org> <20120921152828.GA24364@electric-eye.fr.zoreil.com> <505C98C7.20302@asyr.hopto.org> <20120921175455.GA28255@electric-eye.fr.zoreil.com> <505CC65D.9010605@asyr.hopto.org> <20120924231216.GA20015@electric-eye.fr.zoreil.com> <20120925095403.GA29497@electric-eye.fr.zoreil.com>
In-Reply-To: <20120925095403.GA29497@electric-eye.fr.zoreil.com>
Content-Type: multipart/mixed;
 boundary="------------000107070104020805020506"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000107070104020805020506
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

on 09/25/2012 12:54 PM Francois Romieu wrote the following:
> Thanasis <thanasis@asyr.hopto.org> :
> [...]
>> I don't know what's wrong, but I am getting those errors.
>> Are you sure about the git tree?
> 
> Yes. Replace 'git rev-list --all' with 'git rev-list --branches'.
> 
> It should show something like:
> $ git rev-list --branches
> a65a9b5d9c4569228909e36bb6e20d33fe208950
> 35417352eeec6fcfcb92796d3473ea0ed2624f5e
> [...]
> ec0c1f64e5751d0634c4afad9895c09d9a23da5f
> b8a75250cee0d3c36b62038640b66d185c79fe34
> 
> Then, when test starts:
> [...]
> HEAD is now at b8a7525 3.2 r8169 driver and out-of-tree Makefile.
> 
> Sorry for the confusion.
> 

Ping failed in the following step:

HEAD is now at 3c6ad46 r8169: move rtl_set_rx_mode before its
rtl_hw_start callers.
make -C /lib/modules/3.2.30/build
M=/mnt/usb-disk/atom/usr/src/test-r8169/r8169 modules
make[1]: Entering directory `/usr/src/linux-3.2.30'
  CC [M]  /mnt/usb-disk/atom/usr/src/test-r8169/r8169/r8169.o
  Building modules, stage 2.
  MODPOST 1 modules
  CC      /mnt/usb-disk/atom/usr/src/test-r8169/r8169/r8169.mod.o
  LD [M]  /mnt/usb-disk/atom/usr/src/test-r8169/r8169/r8169.ko
make[1]: Leaving directory `/usr/src/linux-3.2.30'
PING 192.168.0.1 (192.168.0.1) 56(84) bytes of data.
>From 192.168.0.19: icmp_seq=1 Destination Host Unreachable
>From 192.168.0.19: icmp_seq=2 Destination Host Unreachable
>From 192.168.0.19: icmp_seq=3 Destination Host Unreachable

--- 192.168.0.1 ping statistics ---
3 packets transmitted, 0 received, +3 errors, 100% packet loss, time 1999ms
pipe 3

(Full log attached)

--------------000107070104020805020506
Content-Type: application/x-gzip;
 name="3.2.log.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="3.2.log.gz"

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
--------------000107070104020805020506--
