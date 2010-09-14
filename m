Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627Ab0IND2S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 23:28:18 -0400
Received: from vms173013pub.verizon.net ([206.46.173.13]:36217 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107Ab0IND2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 23:28:16 -0400
Date: Mon, 13 Sep 2010 23:27:28 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: trapDoor <trapdoor6@gmail.com>
Cc: Lin Ming <lin@ming.vg>, Miles Lane <miles.lane@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: 2.6.36-rc1-git3 - ACPI Warning: Incorrect checksum in table [OEMB]
 - 0x9C, should be 0x9F (20100702/tbutils-314)
In-reply-to: <AANLkTimBYzPDLug0LFu4ZOtgigt5HVt2ZH=-VB86jpxd@mail.gmail.com>
Message-id: <alpine.LFD.2.00.1009132324500.12119@localhost.localdomain>
References: <AANLkTinva4FS2oonhQSWr25WsRr1M0hOmrGH9penkrbK@mail.gmail.com>
 <AANLkTin4oE-bmXOWzboTccBda1mwY1=Ob56CByb=rg=m@mail.gmail.com>
 <AANLkTimBYzPDLug0LFu4ZOtgigt5HVt2ZH=-VB86jpxd@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm getting exactly the same message on the same kernel

Do you get the message in your dmesg,
or do you have to find in /sys and tail all the files
to get it?  (and does your system hang when you do so?)

If yes, please update https://bugzilla.kernel.org/show_bug.cgi?id=17051

If no, please clarify.

> and also
> another ACPI warning:
> 
> [    0.000000] ACPI Warning: Optional field Pm2ControlBlock has zero
> address or length: 0x0000000000000000/0x1 (20100702/tbfadt-557)

please open a bugzilla for this -- it seems you have some company
and we should not be  bugging people with such messages.

thanks,
-Len Brown, Intel Open Source Technology Center


