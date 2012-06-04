Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271Ab2FDOPT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 10:15:19 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38693 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118Ab2FDOPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 10:15:17 -0400
Message-ID: <1E5B7565E9E847F4B587D9A938F5959F@local.st.by>
From: "Victor Miasnikov" <vvm@tut.by>
To: "KY Srinivasan" <kys@microsoft.com>,
        "Greg KH" <gregkh@linuxfoundation.org>
Cc: <stable@vger.kernel.org>, "Jonathan Nieder" <jrnieder@gmail.com>,
        <linux-kernel@vger.kernel.org>,
        "Mike Sterling" <mike.sterling@microsoft.com>
References: <20120527010903.GA18244@kroah.com> <B4A84D892D5742FE83F71F788F6EAF48@local.st.by> <20120528203518.GA12623@kroah.com> <5EBD7E368EFE4B5CABF4AC528058A4DB@local.st.by> <20120601092017.GE22821@kroah.com> <59CBCFF13ABD41B682835DD5E4851BC1@local.st.by> <20120601162629.GA11812@kroah.com> <426367E2313C2449837CD2DE46E7EAF90710C295@SN2PRD0310MB382.namprd03.prod.outlook.com> <20120602012249.GA7783@kroah.com> <ACB4012399AF4F20A8DAECA154E96ED3@local.st.by> <426367E2313C2449837CD2DE46E7EAF90710CAD0@SN2PRD0310MB382.namprd03.prod.outlook.com>
Subject: Re: Linux on Hyper-V 1) cd006086fa5d ata_piix: defer disks to the Hyper-V drivers by default 2) db63a4c8115a libata: add a host flag to ignore detected ATA device FW: use hv_storvsc instead of ata_piix to handle the IDE disks devices ( but not for the ...
Date: Mon, 4 Jun 2012 17:15:12 +0300
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

> VVM > > > Hyper-V admins need _worked_ Linux v3.4.X / v3.3.X / v3.2.X
>I can help you with the ata patch on specific set of distros of interest. 
>If the system that you are interested loads the ata_piix module, 
>we can solve the issue on hand using modprobe rules rather than a patch against the ata driver.

 K.Y.:  Youre _theory_ ( about "can solve the issue on hand using modprobe rules") is wrong for:
 -- OpenSUSE
 -- Ubuntu
 -- Debian
 
Why You think, what theory can solve problem in other case?

How about LiveCD ? 


But "patch against the ata driver" -- solve problem 100% / 100%


Best regards, Victor Miasnikov
Blog:  http://vvm.blog.tut.by/

P.S.

>Victor, what distro are you using. 
>Let me know.

But Hyper-V admins need "result"  -- if You can fix _all_ what need by "modprobe rules" -- fix issue in:


Kernel:
3.5  -- done
3.4.latest
3.3.latest
3.2.latest

Distro:
  -- Arch Linux
  -- Chacra
  -- _all_ LiveCD
  -- Gentoo
  -- Debian
  -- Fedora


