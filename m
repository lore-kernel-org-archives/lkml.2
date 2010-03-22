Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927Ab0CVRRo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 13:17:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41268 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754688Ab0CVRRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 13:17:41 -0400
Date: Mon, 22 Mar 2010 10:12:38 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alex Villacis Lasso <avillaci@ceibo.fiec.espol.edu.ec>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       Linux Wireless List <linux-wireless@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>
Subject: Re: 2.6.34-rc2: Reported regressions from 2.6.33
In-Reply-To: <M9dVcHY7TxH.A.2GC.ZBopLB@chimera>
Message-ID: <alpine.LFD.2.00.1003221012270.18017@i5.linux-foundation.org>
References: <M9dVcHY7TxH.A.2GC.ZBopLB@chimera>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 21 Mar 2010, Rafael J. Wysocki wrote:
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15495
> Subject		: Flood of SELinux denials on polkitd
> Submitter	: Alex Villacis Lasso <avillaci@ceibo.fiec.espol.edu.ec>
> Date		: 2010-03-09 16:47 (13 days old)

Fixed by commit 3836a03d978e68b0ae00d3589089343c998cd4ff ("anon_inodes: 
mark the anon inode private"), I'm pretty sure.

		Linus
