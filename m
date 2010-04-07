Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060Ab0DGW0d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 18:26:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43143 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753883Ab0DGW0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 18:26:30 -0400
Date: Wed, 7 Apr 2010 15:22:20 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       Linux Wireless List <linux-wireless@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>
Subject: Re: 2.6.34-rc3-git6: Reported regressions from 2.6.33
In-Reply-To: <20100407221941.GL30031@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.2.00.1004071521500.3586@i5.linux-foundation.org>
References: <6Pphclm24fK.A.lSF.qsPvLB@chimera> <alpine.LFD.2.00.1004071444440.3586@i5.linux-foundation.org> <20100407221941.GL30031@ZenIV.linux.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Apr 2010, Al Viro wrote:
> 
> No, it's not the same thing; the fix is to have nfs ->d_revalidate()
> return an error on failing open attempt (in insane codepath that has
> ->d_revalidate() handling open()).  Confirmed to work by reporter...

Ok, can you do the proper changelog description and sign-offs etc?

		Linus
