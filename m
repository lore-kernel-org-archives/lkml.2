Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767Ab1HHING (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 04:13:06 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48683 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab1HHINC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 04:13:02 -0400
MIME-Version: 1.0
In-Reply-To: <CAC-yRPQegTVC6DPMC=-F2GazS5Nsf+SvbuKqv2x3QRypnTFkhA@mail.gmail.com>
References: <CAC-yRPQegTVC6DPMC=-F2GazS5Nsf+SvbuKqv2x3QRypnTFkhA@mail.gmail.com>
Date: Mon, 8 Aug 2011 11:13:00 +0300
Message-ID: <CANMAZFUqg=7j3TSn0HuMn2+ifgd=Bk+qsMUAQqwdwps5vs0=nQ@mail.gmail.com>
Subject: Re: new kernel boot
From: Eduard Sinelnikov <eduard.sinelnikov@gmail.com>
To: Amirali Shambayati <amirali.shambayati@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        kernelnewbies@kernelnewbies.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I got this problem ( compiled kernel from scratch )
Your problem is that the modules is not competible with your ramfs(the
initial OS before loading the real Kernel) file.
( this file is /boot/initrd.img.2-6...... )

I have to create the ramfs via mkinitramfs command

also you have to update the grub to point to the new ramfs file.

Eduard Sinelnikov.

2011/8/8 Amirali Shambayati <amirali.shambayati@gmail.com>:
> Hi all,
> I successfully installed new kernel but as new kernel is going to
> boot, I receive this error:
> FATAL:could not load /lib/modules/2.6.32.43kerneltest/modules.dep : No
> such file or directory
>
> I checked /lib/modules/2.6.32.43kerneltest directory, and modules.dep
> exists! Any guidance how can I solve the problem?
>
> Thanks in advance,
> --
> Amirali Shambayati
> Bachelor Student
> Computer Engineering Department
> Sharif University of Technology
> Tehran, Iran
>
> _______________________________________________
> Kernelnewbies mailing list
> Kernelnewbies@kernelnewbies.org
> http://lists.kernelnewbies.org/mailman/listinfo/kernelnewbies
>
