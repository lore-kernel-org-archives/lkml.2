Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402Ab1HCTST (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 15:18:19 -0400
Received: from vms173011pub.verizon.net ([206.46.173.11]:63076 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754948Ab1HCTSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 15:18:13 -0400
Date: Wed, 03 Aug 2011 15:17:59 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Andrew Lutomirski <luto@mit.edu>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Fenghua Yu <fenghua.yu@intel.com>, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: Enable monitor/mwait on Intel if BIOS hasn't
 already
In-reply-to: <CAObL_7FNa20Hsd0v-hs1vz=ejnkdaT+Yr=wwM681GbZJiuLkMQ@mail.gmail.com>
Message-id: <alpine.LFD.2.02.1108031514550.22067@x980>
References: <cover.1312386029.git.luto@mit.edu>
 <5bec80947da3fb72f2f18fbe6d924a69f83fbed9.1312386029.git.luto@mit.edu>
 <alpine.LFD.2.02.1108031214470.22067@x980>
 <CAObL_7GuAmzyjo5AmYxbTeiAqFtVk1N+opzWEzwJu8Mgrvts7g@mail.gmail.com>
 <CAObL_7FNa20Hsd0v-hs1vz=ejnkdaT+Yr=wwM681GbZJiuLkMQ@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: MULTIPART/MIXED; BOUNDARY="8323328-18042863-1312399079=:22067"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-18042863-1312399079=:22067
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

> >> What machine has this BIOS bug, and are you running
> >> the latest version of the BIOS?
> >
> > Intel DQ67SW, version SWQ6710H.86A.0051.2011.0413.1154.  This is not
> > quite up-to-date -- I'll test a newer BIOS.
> 
> SWQ6710H.86A.0053.2011.0615.1535 has the same problem.  It fixed ASPM, though :)
> 
> Should I redo the patch with a printk to warn about the firmware bug?

I would hope that a patch that _only_ prints [Firmware bug]
should be enough.  This isn't the kind of workaround
that we should really have to carry in the kernel.

This is still a very new platform, and my guess is that
they are actively updating the BIOS as we speak.
I'll see if I can figure out who to talk to
in order to make sure of that:-)

thanks,
Len Brown, Intel Open Source Technology Center


--8323328-18042863-1312399079=:22067--
