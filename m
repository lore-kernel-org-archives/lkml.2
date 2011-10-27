Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498Ab1J0Ts1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 15:48:27 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63672 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab1J0Ts0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 15:48:26 -0400
Subject: Re: [PATCH] config: Add 'make kvmconfig'
From: Sasha Levin <levinsasha928@gmail.com>
To: Rabin Vincent <rabin@rab.in>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kbuild@vger.kernel.org
In-Reply-To: <CAH+eYFBw99Yb-x+QEyZiXZ4yL3r=jr1Z+Gk95DG3hsYLkC_R_A@mail.gmail.com>
References: <1319717234-20918-1-git-send-email-levinsasha928@gmail.com>
	 <CAH+eYFBw99Yb-x+QEyZiXZ4yL3r=jr1Z+Gk95DG3hsYLkC_R_A@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Date: Thu, 27 Oct 2011 22:46:49 +0200
Message-ID: <1319748409.3235.0.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-10-27 at 23:35 +0530, Rabin Vincent wrote:
> On Thu, Oct 27, 2011 at 17:37, Sasha Levin <levinsasha928@gmail.com> wrote:
> > +config KVMTOOL_TEST_ENABLE
> > +       bool "Enable options to create a bootable tools/kvm/ kernel"
> > +       select NET
> > +       select NETDEVICES
> > +       select PCI
> > +       select BLK_DEV
> > +       select NETWORK_FILESYSTEMS
> > +       select INET
> > +       select EXPERIMENTAL
> > +       select SERIAL_8250
> > +       select SERIAL_8250_CONSOLE
> > +       select IP_PNP
> > +       select IP_PNP_DHCP
> > +       select BINFMT_ELF
> > +       select PCI_MSI
> > +       select KGDB
> > +       select KGDB_SERIAL_CONSOLE
> > +       select VIRTIO
> > +       select VIRTIO_RING
> > +       select VIRTIO_PCI
> > +       select VIRTIO_BLK
> > +       select VIRTIO_CONSOLE
> > +       select VIRTIO_NET
> > +       select 9P_FS
> > +       select NET_9P
> > +       select NET_9P_VIRTIO
> 
> This lot doesn't seem to be enough for me on next-20111025.  I seem to
> have to also enable CONFIG_FB_VESA for the kernel to boot.
> 
> Without CONFIG_FB_VESA, I just get:
> 
> $ tools/kvm/kvm run --debug arch/x86/boot/bzImage --disk
> ~/kernel/linux-0.2.img
>   # kvm run -k arch/x86/boot/bzImage -m 448 -c 4 --name guest-11466
> PPrroobbiinngg  EEDDDD  ((eedddd==ooffff  ttoo  ddiissaabbllee))......  ookk
> <no more output>

This is a kvm tools issue and should be fixed within kvm tools.

-- 

Sasha.

