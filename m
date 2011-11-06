Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856Ab1KFRLl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 12:11:41 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37616 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138Ab1KFRLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 12:11:40 -0500
Date: Sun, 6 Nov 2011 19:11:32 +0200 (EET)
From: Pekka Enberg <penberg@cs.helsinki.fi>
X-X-Sender: penberg@tux.localdomain
To: Jan Kiszka <jan.kiszka@web.de>
cc: Pekka Enberg <penberg@kernel.org>, Avi Kivity <avi@redhat.com>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Alexander Graf <agraf@suse.de>, Blue Swirl <blauwirbel@gmail.com>,
        =?ISO-8859-15?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] KVM: Add wrapper script around QEMU to test kernels
In-Reply-To: <4EB6B83E.8050002@web.de>
Message-ID: <alpine.LFD.2.02.1111061906440.1646@tux.localdomain>
References: <1320543320-32728-1-git-send-email-agraf@suse.de> <CAOJsxLENwuDgt1S2O8XMsgp9uet92gWeS=GFP_6QgW2w7bRQrw@mail.gmail.com> <4EB65C5B.8070709@redhat.com> <CAOJsxLEi9TU7zHzcH8KScMNm3CRyJA=ANR3ujWX3cqGFqkUxJw@mail.gmail.com> <4EB66036.4080102@redhat.com>
 <1320577728.1428.73.camel@jaguar> <4EB67486.1070105@redhat.com> <CAOJsxLE2_ce+SCT25cmS7iFuH3SyJeYRNHjxG5iBPkodTX1AoA@mail.gmail.com> <4EB67D17.7000701@redhat.com> <CAOJsxLGRDeMg1CWJ+A6zYCb7dZnm1cm7UL0UVipmJJk4GFGtWA@mail.gmail.com> <4EB680D9.2070706@redhat.com>
 <CAOJsxLFpNG1iZt8=XU2xH3x9dFCqjM=+i8y4EMPg0Ah47bYfqg@mail.gmail.com> <4EB6B385.4070804@web.de> <CAOJsxLH5Vgk7tyr=RAEc=S2JhZ7n2JxOiUL9L91P_Bey+AuFUA@mail.gmail.com> <4EB6B83E.8050002@web.de>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Nov 2011, Jan Kiszka wrote:
>> Can you please share your kernel .config with me and I'll take a look
>> at it. We now have a "make kvmconfig" makefile target for enabling all
>> the necessary config options for guest kernels. I don't think any of
>> us developers are using SUSE so it can surely be a KVM tool bug as
>> well.
>
> Attached.

It hang here as well. I ran

   make kvmconfig

on your .config and it works. It's basically these two:

@@ -1478,7 +1478,7 @@
  CONFIG_NETPOLL=y
  # CONFIG_NETPOLL_TRAP is not set
  CONFIG_NET_POLL_CONTROLLER=y
-CONFIG_VIRTIO_NET=m
+CONFIG_VIRTIO_NET=y
  # CONFIG_VMXNET3 is not set
  # CONFIG_ISDN is not set
  # CONFIG_PHONE is not set
@@ -1690,7 +1690,7 @@
  # CONFIG_SERIAL_PCH_UART is not set
  # CONFIG_SERIAL_XILINX_PS_UART is not set
  CONFIG_HVC_DRIVER=y
-CONFIG_VIRTIO_CONSOLE=m
+CONFIG_VIRTIO_CONSOLE=y
  CONFIG_IPMI_HANDLER=m
  # CONFIG_IPMI_PANIC_EVENT is not set
  CONFIG_IPMI_DEVICE_INTERFACE=m

 			Pekka
