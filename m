Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab2IVIo2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 04:44:28 -0400
Received: from cust-218-222.on4.ontelecoms.gr ([92.118.218.222]:55234 "EHLO
	vergina.dyndns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243Ab2IVIo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 04:44:26 -0400
Message-ID: <505D7A68.8040906@asyr.hopto.org>
Date: Sat, 22 Sep 2012 11:44:24 +0300
From: Thanasis <thanasis@asyr.hopto.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120913 Thunderbird/15.0.1
MIME-Version: 1.0
To: Francois Romieu <romieu@fr.zoreil.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: Re: RTL8101E/RTL8102E PCI Express Fast Ethernet controller (rev 02)
References: <505B5C11.1050503@asyr.hopto.org> <CAErSpo6W0zy+HkRWW9bE=Ma--9vwgjrOWin8d5QNvUJWQtwM0w@mail.gmail.com> <20120920232030.GA9224@electric-eye.fr.zoreil.com> <505BF437.4090506@asyr.hopto.org> <20120921152828.GA24364@electric-eye.fr.zoreil.com> <505C98C7.20302@asyr.hopto.org> <20120921175455.GA28255@electric-eye.fr.zoreil.com> <505CBDF9.9020503@asyr.hopto.org> <20120921202957.GA32502@electric-eye.fr.zoreil.com> <505CD982.2000409@asyr.hopto.org> <20120921225343.GA2938@electric-eye.fr.zoreil.com>
In-Reply-To: <20120921225343.GA2938@electric-eye.fr.zoreil.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on 09/22/2012 01:53 AM Francois Romieu wrote the following:

>>> Could you perform a test with ... 3.2-something kernel and its
>>> r8169 driver ?

As I said in my previous mail, I tried the r8169 of 3.2.30 and it works.

FWIW, while compiling the 3.2.30 kernel I saw this warning:

drivers/usb/storage/realtek_cr.c: In function ‘init_realtek_cr’:
drivers/usb/storage/realtek_cr.c:477:33: warning: ‘buf[15]’ may be used
uninitialized in this function [-Wuninitialized]
drivers/usb/storage/realtek_cr.c:456:5: note: ‘buf[15]’ was declared here
drivers/usb/storage/realtek_cr.c:476:33: warning: ‘buf[14]’ may be used
uninitialized in this function [-Wuninitialized]
drivers/usb/storage/realtek_cr.c:456:5: note: ‘buf[14]’ was declared here
drivers/usb/storage/realtek_cr.c:475:50: warning: ‘buf[13]’ may be used
uninitialized in this function [-Wuninitialized]
drivers/usb/storage/realtek_cr.c:456:5: note: ‘buf[13]’ was declared here
drivers/usb/storage/realtek_cr.c:473:30: warning: ‘buf[12]’ may be used
uninitialized in this function [-Wuninitialized]
drivers/usb/storage/realtek_cr.c:456:5: note: ‘buf[12]’ was declared here
drivers/usb/storage/realtek_cr.c:472:31: warning: ‘buf[11]’ may be used
uninitialized in this function [-Wuninitialized]
drivers/usb/storage/realtek_cr.c:456:5: note: ‘buf[11]’ was declared here
drivers/usb/storage/realtek_cr.c:471:31: warning: ‘buf[10]’ may be used
uninitialized in this function [-Wuninitialized]
drivers/usb/storage/realtek_cr.c:456:5: note: ‘buf[10]’ was declared here
drivers/usb/storage/realtek_cr.c:470:30: warning: ‘buf[9]’ may be used
uninitialized in this function [-Wuninitialized]
drivers/usb/storage/realtek_cr.c:456:5: note: ‘buf[9]’ was declared here
drivers/usb/storage/realtek_cr.c:469:27: warning: ‘buf[8]’ may be used
uninitialized in this function [-Wuninitialized]
drivers/usb/storage/realtek_cr.c:456:5: note: ‘buf[8]’ was declared here
drivers/usb/storage/realtek_cr.c:469:43: warning: ‘buf[7]’ may be used
uninitialized in this function [-Wuninitialized]
drivers/usb/storage/realtek_cr.c:456:5: note: ‘buf[7]’ was declared here
drivers/usb/storage/realtek_cr.c:468:30: warning: ‘buf[6]’ may be used
uninitialized in this function [-Wuninitialized]
drivers/usb/storage/realtek_cr.c:456:5: note: ‘buf[6]’ was declared here
drivers/usb/storage/realtek_cr.c:467:30: warning: ‘buf[5]’ may be used
uninitialized in this function [-Wuninitialized]
drivers/usb/storage/realtek_cr.c:456:5: note: ‘buf[5]’ was declared here
drivers/usb/storage/realtek_cr.c:466:28: warning: ‘buf[4]’ may be used
uninitialized in this function [-Wuninitialized]
drivers/usb/storage/realtek_cr.c:456:5: note: ‘buf[4]’ was declared here
drivers/usb/storage/realtek_cr.c:465:24: warning: ‘buf[3]’ may be used
uninitialized in this function [-Wuninitialized]
drivers/usb/storage/realtek_cr.c:456:5: note: ‘buf[3]’ was declared here
drivers/usb/storage/realtek_cr.c:465:40: warning: ‘buf[2]’ may be used
uninitialized in this function [-Wuninitialized]
drivers/usb/storage/realtek_cr.c:456:5: note: ‘buf[2]’ was declared here
drivers/usb/storage/realtek_cr.c:464:24: warning: ‘buf[1]’ may be used
uninitialized in this function [-Wuninitialized]
drivers/usb/storage/realtek_cr.c:456:5: note: ‘buf[1]’ was declared here
drivers/usb/storage/realtek_cr.c:464:40: warning: ‘buf[0]’ may be used
uninitialized in this function [-Wuninitialized]
drivers/usb/storage/realtek_cr.c:456:5: note: ‘buf[0]’ was declared here

