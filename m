Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798Ab1HDVzF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 17:55:05 -0400
Received: from vms173017pub.verizon.net ([206.46.173.17]:38621 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754463Ab1HDVy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 17:54:59 -0400
Date: Thu, 04 Aug 2011 17:54:04 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Andrew Lutomirski <luto@mit.edu>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Fenghua Yu <fenghua.yu@intel.com>,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: Enable monitor/mwait on Intel if BIOS hasn't
 already
In-reply-to: <20110804194117.GA5265@srcf.ucam.org>
Message-id: <alpine.LFD.2.02.1108041751360.24626@x980>
References: <cover.1312386029.git.luto@mit.edu>
 <5bec80947da3fb72f2f18fbe6d924a69f83fbed9.1312386029.git.luto@mit.edu>
 <alpine.LFD.2.02.1108031214470.22067@x980>
 <CAObL_7GuAmzyjo5AmYxbTeiAqFtVk1N+opzWEzwJu8Mgrvts7g@mail.gmail.com>
 <CAObL_7FNa20Hsd0v-hs1vz=ejnkdaT+Yr=wwM681GbZJiuLkMQ@mail.gmail.com>
 <alpine.LFD.2.02.1108031514550.22067@x980>
 <20110804194117.GA5265@srcf.ucam.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We can't trust BIOS authors to get things right. Where we can reliably 
> fix up things that are broken, we should do so.

How about if we can get a BIOS fix for this brand new system,
then we shall not clutter the kernel with a workaround,
otherwise we shall.

thanks,
-Len

