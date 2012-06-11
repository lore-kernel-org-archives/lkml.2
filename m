Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab2FKDiH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 23:38:07 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:47243 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877Ab2FKDhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 23:37:45 -0400
MIME-Version: 1.0
In-Reply-To: <CANc+2y7dMRQ2C-oTU94gBA11CDrwZFthzOvM4wffV77_wMnchQ@mail.gmail.com>
References: <CANc+2y48M+K4jvGEes_srYO7rCQcPt4pvcxcvm-Hd+7kKJr6BQ@mail.gmail.com>
	<CAHkwNT=3dGTZTDWi+r7m=K=Pqgv6Txi-xKcpN_pNUJ_WbUaD4w@mail.gmail.com>
	<4FD39A7F.9020106@mvista.com>
	<CAHkwNT=DLCm_gfubGV=_SahM5njpA=Z_miA=SEkVeYA9cHMdmA@mail.gmail.com>
	<CANc+2y7dMRQ2C-oTU94gBA11CDrwZFthzOvM4wffV77_wMnchQ@mail.gmail.com>
Date: Mon, 11 Jun 2012 09:07:44 +0530
Message-ID: <CAHkwNTnRHLaFS5yixojkgExGcW7XM62C3oHEJjiUYY3BioqVZA@mail.gmail.com>
Subject: Re: Break point not hit while debugging linux kernel with kgdb
From: Anil Nair <anilcoll90@gmail.com>
To: prasannatsmkumar <prasannatsmkumar@gmail.com>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Prasanna,

On Sun, Jun 10, 2012 at 10:20 AM, prasannatsmkumar
<prasannatsmkumar@gmail.com> wrote:
> In one of the machines I am facing a scenario:
> I recompiled Ubuntu linux kernel (with the default config taken from
> /boot) and the newly compiled kernel does not boot. After detecting
> the hard disk (SCSI device) it panics.

Did you compile the kernel using standard step? Which Ubuntu version
you are trying to install your customized kernel? What is the kernel
version you are trying to compile? For ubuntu distribution standard
steps are given at their site for compiling customized kernel, i
followed those steps and was able to compile and install customized
kernel. Here is the link for it,

https://help.ubuntu.com/community/Kernel/Compile

>I am able to see only a part of
> the kernel stack trace due to low resolution so I am in a situation
> where I cannot do anything further. In this situation kgdb seems to be
> the only way.

Also, i think so the kernel is in panic due to the reason that it
couldn't find initial ram disk. Did you create an initial ram disk
while compiling and installing the kernel? I came through the same
situation that is why i am asking?
are you using mkinitramfs command for creating ramdisk? trying using
update-initrd command, google for it i forgot its usage.! :). After
creating ramdisk move it to the /boot directory and update the grub
using the update-grub command.


I hope this may solve you problem. :)

-- 
Regards,
Anil Nair
