Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641Ab0DFUsN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 16:48:13 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:61529 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755649Ab0DFUsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 16:48:07 -0400
Date: Tue, 06 Apr 2010 16:47:47 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT pull request] ACPI patches for 2.6.34-rc3
In-reply-to: <h2ub170af451004060025oe838072pada57b715e18c235@mail.gmail.com>
Message-id: <alpine.LFD.2.00.1004061646170.4168@localhost.localdomain>
References: <alpine.LFD.2.00.1004060308030.21994@localhost.localdomain>
 <h2ub170af451004060025oe838072pada57b715e18c235@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: MULTIPART/MIXED; BOUNDARY="8323328-625824257-1270586868=:4168"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-625824257-1270586868=:4168
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT


On Tue, 6 Apr 2010, Rafał Miłecki wrote:

> W dniu 6 kwietnia 2010 09:09 użytkownik Len Brown <lenb@kernel.org> napisał:
> > commit c8cf3a14a6615e06504664cd50ca90baa5f2ef7d
> > Author: Rafael Wysocki <rjw@sisk.pl>
> > Date:   Thu Mar 4 00:25:30 2010 +0000
> >
> >    ACPI / PM: Move ACPI video resume to a PM notifier
> >
> >    There is a problem with the ACPI video resume routine that it's
> >    executed before the GPU that may be accessed by it.  To fix this
> >    issue, move the ACPI video resume to a power management notifier,
> >    so that it's executed after resuming all devices, including the GPU.
> >
> >    http://bugzilla.kernel.org/show_bug.cgi?id=15096
> >
> >    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> >    Acked-by: Matthew Garrett <mjg@redhat.com>
> >    Tested-by: Rafał Miłecki <zajec5@gmail.com>
> >    Signed-off-by: Len Brown <len.brown@intel.com>
> 
> Could you push this one to stable as well, please? It partially fixes
> regression reported in:
> https://bugzilla.kernel.org/show_bug.cgi?id=15096
> 
> This should go to .32 and .33.

Yes, after it is upstream, it can be sent to .stable.
In this case it applies to .33, and will need some modification for .32
At that point, the bugzilla entry is closed.

cheers,
Len Brown, Intel Open Source Technology Center


--8323328-625824257-1270586868=:4168--
