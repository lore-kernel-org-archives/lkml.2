Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757978Ab2IUUs3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 16:48:29 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:59497 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757744Ab2IUUs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 16:48:28 -0400
Date: Fri, 21 Sep 2012 22:29:57 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Thanasis <thanasis@asyr.hopto.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: Re: RTL8101E/RTL8102E PCI Express Fast Ethernet controller (rev 02)
Message-ID: <20120921202957.GA32502@electric-eye.fr.zoreil.com>
References: <505B522F.9090808@asyr.hopto.org> <CAErSpo4ydsZzrQJCO73mvTEn8TBDVRxg2D0UaHY0XgdyPxJaLQ@mail.gmail.com> <505B5C11.1050503@asyr.hopto.org> <CAErSpo6W0zy+HkRWW9bE=Ma--9vwgjrOWin8d5QNvUJWQtwM0w@mail.gmail.com> <20120920232030.GA9224@electric-eye.fr.zoreil.com> <505BF437.4090506@asyr.hopto.org> <20120921152828.GA24364@electric-eye.fr.zoreil.com> <505C98C7.20302@asyr.hopto.org> <20120921175455.GA28255@electric-eye.fr.zoreil.com> <505CBDF9.9020503@asyr.hopto.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <505CBDF9.9020503@asyr.hopto.org>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanasis <thanasis@asyr.hopto.org> :
> So far, ping has failed *only* at this iteration of the make loop:

Ok.

Without the usual netdev watchdog message I presume ?

[...]
> Now, after 74 iterations, it looks as if the loop is stuck at the following:
> 
> HEAD is now at 1ce4b16 r8169: spinlock redux.
> make -C /lib/modules/2.6.38-r8/build
> M=/mnt/usb-disk/atom/usr/src/test-r8169/r8169 modules
> make[1]: Entering directory `/usr/src/linux-2.6.38-r8'
>   CC [M]  /mnt/usb-disk/atom/usr/src/test-r8169/r8169/r8169.o
>   Building modules, stage 2.
>   MODPOST 1 modules
>   CC      /mnt/usb-disk/atom/usr/src/test-r8169/r8169/r8169.mod.o
>   LD [M]  /mnt/usb-disk/atom/usr/src/test-r8169/r8169/r8169.ko
> make[1]: Leaving directory `/usr/src/linux-2.6.38-r8'
> 
> 
> Should I wait for it to end?

No. I surely f*cked up something.

> Do you want me to post the whole log so far?

Please. It should gzip well. The complete dmesg with timestamps would be
welcome too.

Could you perform a test with your vendor's 3.2-something kernel and its
r8169 driver ?

-- 
Ueimor
