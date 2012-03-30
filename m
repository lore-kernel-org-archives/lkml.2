Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760127Ab2C3JOd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 05:14:33 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51614 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758579Ab2C3JOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 05:14:24 -0400
Message-ID: <6AF6153696DE4E7EB79B86077851A00E@local.st.by>
From: "Victor Miasnikov" <vvm@tut.by>
To: "Andy Whitcroft" <apw@canonical.com>, "Jeff Garzik" <jgarzik@pobox.com>,
        <linux-ide@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, "K. Y. Srinivasan" <kys@microsoft.com>,
        "Mike Sterling" <Mike.Sterling@microsoft.com>
References: <1333042130-9634-1-git-send-email-apw@canonical.com>
Subject: Re: [PATCH 1/1] ata_piix: defer disks to the Hyper-V paravirtualised drivers by default
Date: Fri, 30 Mar 2012 12:14:20 +0300
MIME-Version: 1.0
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.3790.4548
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4862
Content-Type: text/plain;
	format=flowed;
	charset="koi8-r";
	reply-type=original
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi!

----- Original Message ----- 
From: "Andy Whitcroft" apw
Sent: Thursday, March 29, 2012 8:28 PM
Subject: [PATCH 1/1] ata_piix: defer disks to the Hyper-V paravirtualised drivers by default

> guest disks are exposed both via the Hyper-V paravirtualised drivers and via an emulated SATA disk
> controller.   . . .  we need to prevent the
> ata_piix driver from claiming the disks devices by default when running
> on a Hyper-V hypervisor.

 Yes

Thanks for patch!

>    Comments?

 This patch is  "UBUNTU Way" Solution described in

See
http://vvm.blog.tut.by/2012/03/29/linux-on-hyper-v-use-hv_storvsc-instead-of-ata_piix-to-handle-the-ide-disks-devices-but-not-for-the-dvd-rom-cd-rom-device-handling/
Or

http://marc.info/?l=linux-kernel&m=133302969709312&w=2
==
List: linux-kernel
Subject: Linux on Hyper-V -- use hv_storvsc instead of ata_piix to handle the IDE disks devices ( but not for the 
DVD-ROM / CD-ROM device handling) Fw: [PATCH RFC] ata_piix: ignore disks in a hyper-v guest
From: "Victor Miasnikov"
Date: 2012-03-29 14:00:05

. . .

"UBUNTU Way" Solution -- tested with
Ubuntu 12.04 LTS (Precise Pangolin) Daily Build 2012-03-13
precise-desktop-amd64.iso
, work Ok
. . .
==



i.e. "[PATCH 1/1] ata_piix: defer disks to the Hyper-V paravirtualised drivers by default"  is fully worked solution to 
the described problem


Best regards, Victor Miasnikov
Blog:  http://vvm.blog.tut.by/ 

