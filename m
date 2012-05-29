Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671Ab2E2Gec (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 02:34:32 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55928 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab2E2Geb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 02:34:31 -0400
Message-ID: <5EBD7E368EFE4B5CABF4AC528058A4DB@local.st.by>
From: "Victor Miasnikov" <vvm@tut.by>
To: "Greg KH" <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
Cc: "Jonathan Nieder" <jrnieder@gmail.com>, <linux-kernel@vger.kernel.org>,
        "KY Srinivasan" <kys@microsoft.com>
References: <20120527010903.GA18244@kroah.com> <B4A84D892D5742FE83F71F788F6EAF48@local.st.by> <20120528203518.GA12623@kroah.com>
Subject: Linux on Hyper-V 1) cd006086fa5d ata_piix: defer disks to the Hyper-V drivers by default 2) db63a4c8115a libata: add a host flag to ignore detected ATA device FW: use hv_storvsc instead of ata_piix to handle the IDE disks devices ( but not for the CD-ROM)
Date: Tue, 29 May 2012 09:34:23 +0300
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


> And it's too late for 3.4.1, as that is already out for review.

 Ok: "Please, backport to 3.4.2"

{ P.S.
And "to 3.3.x" and "to 3.2.x"  i.e. to all actual version after 3.1

}

>>> use hv_storvsc instead of ata_piix to handle the IDE disks devices ( but not for the CD-ROM)
VVM> Please, backport to 3.4.2-stable all related this:
>>      ...Ugly MSFT Hyper-V workaround in ata_piix
>>      ata_piix: defer disks to the Hyper-V drivers...

> I do not understand, what exactly are the git commit ids that you wish
> to see applied to the stable tree?

 Sorry:

 1)
db63a4c8115a0bb904496e1cdd3e7488e68b0d06
 2)
cd006086fa5d91414d8ff9ff2b78fbb593878e3c

{
Jonathan Nieder think:

  cd006086fa5d ata_piix: defer disks to the Hyper-V drivers by default

and its prerequisite

  db63a4c8115a libata: add a host flag to ignore detected ATA devices

}


Some details:
1:
http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;h=db63a4c8115a0bb904496e1cdd3e7488e68b0d06
==
libata: add a host flag to ignore detected ATA devices
      author Andy Whitcroft < apw ( at ) canonical.com >
     Fri, 4 May 2012 21:15:10 +0000 (22:15 +0100)
      committer Jeff Garzik < jgarzik ( at ) redhat.com >
     Mon, 7 May 2012 19:32:23 +0000 (15:32 -0400)
      commit db63a4c8115a0bb904496e1cdd3e7488e68b0d06
      tree 326448b28bf8de7c6205ed9e598070111e8a5020
==

2:
http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;h=cd006086fa5d91414d8ff9ff2b78fbb593878e3c;hp=db63a4c8115a0bb904496e1cdd3e7488e68b0d06
==
ata_piix: defer disks to the Hyper-V drivers by default
      author Andy Whitcroft  < apw ( at ) canonical.com >
     Fri, 4 May 2012 21:15:11 +0000 (22:15 +0100)
      committer Jeff Garzik < jgarzik ( at ) redhat.com >
     Mon, 7 May 2012 19:32:58 +0000 (15:32 -0400)
      commit cd006086fa5d91414d8ff9ff2b78fbb593878e3c

==


Best regards, Victor Miasnikov
Blog:  http://vvm.blog.tut.by/

