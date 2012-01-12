Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205Ab2ALXvM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 18:51:12 -0500
Received: from snt0-omc1-s27.snt0.hotmail.com ([65.55.90.38]:6180 "EHLO
	snt0-omc1-s27.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755124Ab2ALXvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 18:51:11 -0500
Message-ID: <SNT123-W46318F430CE810154029D5DB9F0@phx.gbl>
X-Originating-IP: [173.161.69.124]
From: Greg White <pcguy11@live.com>
To: <greg@kroah.com>
CC: <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: =?windows-1256?Q?RE:_MULTIP?= =?windows-1256?Q?LE_WARNING?=
 =?windows-1256?Q?:_at_fs/sy?= =?windows-1256?Q?sfs/dir.c:?=
 =?windows-1256?Q?455_sysfs=5F?= =?windows-1256?B?YWRkX29uZf7+?=
Date: Thu, 12 Jan 2012 17:51:10 -0600
Importance: Normal
In-Reply-To: <20120112213702.GA17405@kroah.com>
References: <SNT123-W206618A1B501B8A491DFADDB9F0@phx.gbl>,<20120112213702.GA17405@kroah.com>
Content-Type: text/plain; charset="windows-1256"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
X-OriginalArrivalTime: 12 Jan 2012 23:51:10.0973 (UTC) FILETIME=[0F9D62D0:01CCD185]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Thu, Jan 12, 2012 at 02:40:18PM -0600, Greg W wrote:
> >
> > Hi,
> >
> > I just installed Linux on my HP 6200 PC using UEFI. The Ubuntu lucid kernel caused my computer to freeze during shutdown and reboots. So I downloaded 3.1.6 from kernel.org and compiled my own kernel and it works fine except for the following messages in my dmesg:
> >
> > [2.295957] ------------[ cut here ]------------
> > [2.295962] WARNING: at fs/sysfs/dir.c:455 sysfs_add_one+0xc1/0xf0()
> > [2.295964] Hardware name: HP Compaq 6200 Pro Small Form Factor
> > [2.295966] sysfs: cannot create duplicate filename '/firmware/efi/vars/SlotPresent-ec87d643-eba4-4bb5-a1e5-3f3e36b20da9'
>
> This is a BIOS problem, with EFI, go complain to your manufacturer that
> they are creating multiple slots with the same name.
>
> > [2.296043] kobject_add_internal failed for
> > SlotPresent-ec87d643-eba4-4bb5-a1e5-3f3e36b20da9 with -EEXIST, don't try to register things with the same name in the same directory.
>
> See, the kernel told you this :)
>
> best of luck,
>
> greg k-h

Thank you for the clarification.  When I see WARNING: at fs/sysfs/dir.c:455 sysfs_add_one+0xc1/0xf0() I think kernel problem.  If I saw WARNING: BIOS is trying to register things with the same name in the same directory, I would have thought BIOS issue.  Maybe you could make the warning a little more clear the problem is in the BIOS and not the kernel?

I already have an open service request with HP to fix three other bugs in their BIOS.  I will add this to the list.  Now if I could just get someone from HP to contact me and fix the problems.....

Thanks,
Greg

 		 	   		  
