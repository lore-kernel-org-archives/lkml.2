Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618Ab2E1OSL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 10:18:11 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45633 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122Ab2E1OSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 10:18:09 -0400
Message-ID: <B4A84D892D5742FE83F71F788F6EAF48@local.st.by>
From: "Victor Miasnikov" <vvm@tut.by>
To: "Greg KH" <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
Cc: "KY Srinivasan" <kys@microsoft.com>
References: <20120527010903.GA18244@kroah.com>
Subject: Re: [ 00/91] 3.4.1-stable review Fw: [PATCH 1/2] libata: add a host flag to ignore detected ATA devices FW: use hv_storvsc instead of ata_piix to handle the IDE disks devices ( but not for the CD-ROM)
Date: Mon, 28 May 2012 17:18:04 +0300
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.3790.4548
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4862
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

>> use hv_storvsc instead of ata_piix to handle the IDE disks devices ( but not for the CD-ROM)

 Please, backport to 3.4.1-stable all related this:


http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commit;h=59d0952b43552570e0f1c3ff91ebb16d4caec171
==
       days ago Linus Torvalds Merge tag 'upstream-linus' of git://git.kernel.org...
      ...Ugly MSFT Hyper-V workaround in ata_piix
      ata_piix: defer disks to the Hyper-V drivers...


==

i.e.


http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=patch;h=db63a4c8115a0bb904496e1cdd3e7488e68b0d06
===
>From db63a4c8115a0bb904496e1cdd3e7488e68b0d06 Mon Sep 17 00:00:00 2001
From: Andy Whitcroft <apw@canonical.com>
Date: Fri, 4 May 2012 22:15:10 +0100
Subject: [PATCH] libata: add a host flag to ignore detected ATA devices
 . . .
==

and


http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commitdiff_plain;h=cd006086fa5d91414d8ff9ff2b78fbb593878e3c;hp=db63a4c8115a0bb904496e1cdd3e7488e68b0d06
===
From: Andy Whitcroft <apw@canonical.com>
Date: Fri, 4 May 2012 21:15:11 +0000 (+0100)
Subject: ata_piix: defer disks to the Hyper-V drivers by default

 . . .
==



Best regards, Victor Miasnikov
Blog:  http://vvm.blog.tut.by/

