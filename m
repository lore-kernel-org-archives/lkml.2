Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965408Ab2FAQRl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 12:17:41 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39544 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965301Ab2FAQRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 12:17:40 -0400
Message-ID: <59CBCFF13ABD41B682835DD5E4851BC1@local.st.by>
From: "Victor Miasnikov" <vvm@tut.by>
To: "Greg KH" <gregkh@linuxfoundation.org>
Cc: <stable@vger.kernel.org>, "Jonathan Nieder" <jrnieder@gmail.com>,
        <linux-kernel@vger.kernel.org>, "KY Srinivasan" <kys@microsoft.com>
References: <20120527010903.GA18244@kroah.com> <B4A84D892D5742FE83F71F788F6EAF48@local.st.by> <20120528203518.GA12623@kroah.com> <5EBD7E368EFE4B5CABF4AC528058A4DB@local.st.by> <20120601092017.GE22821@kroah.com>
Subject: Re: Linux on Hyper-V 1) cd006086fa5d ata_piix: defer disks to the Hyper-V drivers by default 2) db63a4c8115a libata: add a host flag to ignore detected ATA device FW: use hv_storvsc instead of ata_piix to handle the IDE disks devices ( but not for the CD-R
Date: Fri, 1 Jun 2012 19:17:33 +0300
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="ISO-8859-1";
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

>>  cd006086fa5d ata_piix: defer disks to the Hyper-V drivers by default
>> and its prerequisite
>>  db63a4c8115a libata: add a host flag to ignore detected ATA devices

> Sorry, but I don't see how this meets the rules for the stable trees, do you?  If so, please show me how.

About "how"  -- ask K.Y. Srinivasan

 Hyper-V admins need _worked_ Linux v3.4.X / v3.3.X / v3.2.X

Please, _fix_ errors related "use hv_storvsc instead of ata_piix to handle the IDE disks devices ( but not for the 
CD-ROM)"


 Thanks
Best regards, Victor Miasnikov
Blog:  http://vvm.blog.tut.by/ 

