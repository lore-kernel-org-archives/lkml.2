Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab0D0UXY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 16:23:24 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:35695 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754776Ab0D0UXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 16:23:22 -0400
Subject: Re: 2.6.33.3-rt16 Oops caused by umount
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Xianghua Xiao <xiaoxianghua@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.1004272053130.2951@localhost.localdomain>
References: <l2ye6bf505b1004271144ta6817962vec8167d813658648@mail.gmail.com>
	 <alpine.LFD.2.00.1004272053130.2951@localhost.localdomain>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 27 Apr 2010 13:23:18 -0700
Message-ID: <1272399798.2255.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-27 at 20:56 +0200, Thomas Gleixner wrote:
> On Tue, 27 Apr 2010, Xianghua Xiao wrote:
> 
> cc'ed John
> 
> > 2.6.33.2-rt13 worked fine, however on 2.6.33.3-rt16, when I do reboot, it oops:
> > 
> > # reboot
> > # Oops: Kernel access of bad area, sig: 11 [#1]
> > PREEMPT 83xx Sys
> > Modules linked in:
> > NIP: c00efc68 LR: c00efc38 CTR: 00000000
> > REGS: ce6e3dc0 TRAP: 0300   Not tainted  (2.6.33.3-rt16)
> > MSR: 00009032 <EE,ME,IR,DR>  CR: 24000448  XER: 00000000
> > DAR: 00000038, DSISR: 20000000
> > TASK = cd89ccc0[1613] 'umount' THREAD: ce6e2000
> > GPR00: 00000000 ce6e3e70 cd89ccc0 ce6e3ddc 22222222 00000000 ce6e3e24 ce6e3e04
> > GPR08: 00008000 00000010 cdfa2130 cdfa26e0 44000442 100bbc1c 0fffd000 ffffffff
> > GPR16: 00000001 00000000 007fff00 00000000 00000000 00000001 ce6e3eb8 00000021
> > GPR24: 00000060 00000000 00000000 ceb94c40 00000000 ceb94cc0 c065781c ce6e3e70
> > NIP [c00efc68] fs_may_remount_ro+0x6c/0xd8
> > LR [c00efc38] fs_may_remount_ro+0x3c/0xd8
> > Call Trace:
> > [ce6e3e70] [c00efc38] fs_may_remount_ro+0x3c/0xd8 (unreliable)
> > [ce6e3e90] [c00f1198] do_remount_sb+0x11c/0x164
> > [ce6e3eb0] [c0113a3c] do_mount+0x538/0x86c
> > [ce6e3f10] [c0113e30] sys_mount+0xc0/0x120
> > [ce6e3f40] [c00178d8] ret_from_syscall+0x0/0x38
> > --- Exception: c01 at 0xfe5f8c4
> >     LR = 0x10051b88
> > Instruction dump:
> > 38000000 817d00c0 3bbd00c0 60088000 814b0000 2f8a0000 419e0008 7c00522c
> > 7f8be800 419e004c 812b000c 81290040 <80090028> 2f800000 419e0028 a009006e
> > ---[ end trace 17c711f9d369c3a3 ]---

Hey Xianghua, 
	What filesystem was this on? And what architecture? 

thanks
-john


