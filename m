Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab0HXWgB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 18:36:01 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:53919 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283Ab0HXWfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:35:55 -0400
Date: Tue, 24 Aug 2010 18:35:30 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>, sedat.dilek@gmail.com,
        Andi Kleen <ak@linux.intel.com>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git pull request] ACPI patches for 2.6.36.merge
In-reply-to: <20100816124300.e72258c9.sfr@canb.auug.org.au>
Message-id: <alpine.LFD.2.00.1008241815120.29078@localhost.localdomain>
References: <AANLkTikV2eVo6KM5dSqfDwAwT=bVxnuWSpBE7F+JQU+_@mail.gmail.com>
 <AANLkTi=vngT_5XYz1=3P6GjExFNtCVCdBMhaz4Sc4oEk@mail.gmail.com>
 <20100815133015.883c7069.akpm@linux-foundation.org>
 <AANLkTi=Ok3NH3k5EF1Da2Z3xA7uahABRtH7pEdOEuZH2@mail.gmail.com>
 <20100815182153.994179c1.akpm@linux-foundation.org>
 <AANLkTinBAgk_Ay4vCcTxTEsq-uwn=RwQpTA6O86JXGCM@mail.gmail.com>
 <20100816124300.e72258c9.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My bad.

Andrew was right -- I botched a modify/delete
merge conflict of two correct patches.
I did it at the last minute and then fed the wrong branch
("idle-release" instead of "release") to my build test,
send the code, and dropped of the net.  multiple mistakes.

Sorry for the sloppiness, I'll do better.

Upon the git merge conflict, it looks like I resorted to
pulling andi's original patch out of git, pushing it into
quilt on top of rui's delete; and then got fooled
by the refresh.  Should have caught that both by inspection
and by build...

On a positive note, the underlying reason for the conflict
was that we are succeeding in deleting a bunch of crufty code
that should not need to be maintained at all:-)

thanks,
Len Brown, Intel Open Source Technology Center
