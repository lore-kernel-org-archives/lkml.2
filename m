Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760360Ab0EEACw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 20:02:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60516 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756607Ab0EEACt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 20:02:49 -0400
Date: Tue, 4 May 2010 17:00:32 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
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
Subject: Re: 2.6.34-rc6-git2: Reported regressions from 2.6.33
In-Reply-To: <JzEGxUyyQHG.A.ZtH.YHJ4LB@chimera>
Message-ID: <alpine.LFD.2.00.1005041654400.5478@i5.linux-foundation.org>
References: <JzEGxUyyQHG.A.ZtH.YHJ4LB@chimera>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 4 May 2010, Rafael J. Wysocki wrote:
> 
> Unresolved regressions
> ----------------------
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15880
> Subject		: Very bad regression from 2.6.33 as of 1600f9def
> Submitter	: Alex Elsayed <eternaleye@gmail.com>
> Date		: 2010-04-29 2:28 (6 days old)
> Message-ID	: <loom.20100429T041908-663@post.gmane.org>
> References	: http://marc.info/?l=linux-kernel&m=127250825306178&w=2

This looks like it wasn't a regression, but some other compile/install 
issue. See

	http://marc.info/?l=linux-kernel&m=127274294422719&w=2

where he reports that his self-compiled 2.6.33 doesn't boot either. 

There's some confusion about .config, but it might well be an install 
problem too (in fact, that sounds more likely - the original bug-report 
seems to reboot before the kernel has really even booted - it apparently 
hasn't done the graphics mode switch by the early bootloader)

		Linus
