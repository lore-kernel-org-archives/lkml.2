Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab1DDUON (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 16:14:13 -0400
Received: from cantor.suse.de ([195.135.220.2]:38898 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752841Ab1DDUOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 16:14:12 -0400
From: Thomas Renninger <trenn@suse.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [SUBMIT REQUEST] cpupowerutils for linux-next
Date: Mon, 4 Apr 2011 22:14:00 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc5-5.99.12.5343e5f-desktop; KDE/4.4.4; x86_64; ; )
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
        Len Brown <lenb@kernel.org>, "Greg Kroah-Hartman" <gregkh@novell.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Linus <torvalds@linux-foundation.org>
References: <201104041510.56570.trenn@suse.de> <20110405004011.0628991a.sfr@canb.auug.org.au>
In-Reply-To: <20110405004011.0628991a.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201104042214.01501.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 April 2011 16:40:11 Stephen Rothwell wrote:
> Hi Thomas,
> 
> On Mon, 4 Apr 2011 15:10:56 +0200 Thomas Renninger <trenn@suse.de>
> wrote:
> >
> > this is about the recently announced cpupowerutils project
> > based on or say an enhancement of the well know
> > cpufrequtils project:
> > http://www.spinics.net/lists/cpufreq/msg02137.html
> 
> Has integration of this into the kernel sources been discussed
> anywhere generally (like lkml)?
This is the first submit request.
> Has the work been done to integrate it into the
> kernel build system (I am not sure what this involves for the tools
> directory). 
No, it's separated like perf (but it is by far not that complex and
has not that much dependencies) or like tools/power/x86.

> At a first glance, it doesn't need it own copy of the
> COPYING file (for example).
While cpufrequtils has been developed by people working with
the kernel, there are probably more things like this to clean up
and get adopted.
It would be great to have it in linux-next for a while to get such
stuff addressed and cleaned up.
 
> I see that you asked Linus about this, but have receibed no reply (on
> list).
It was not very clever to simply add Linus into CC of this announcement,
asking for integration in the middle of a merge window...
 
> Code being merged into linux-next should be basically ready for
> merging into Linus' tree (apart from integration testing) and you need
> to be pretty sure that it will be merged by Linus into the next
> release (i.e. 2.6.40).  In this case that is not such a big issue as
> the code is (currently) all in a new directory, so will not interfere
> with other code.
Yes, it's totally separated and will not interfere.
80% of the code (cpufrequtils) is mature and well tested for years.
Recent changes are the cpuidle (cpupower idle-info) and monitor
parts. The integration to have one binary (command subcommand
style like perf/git/guilt/...), invoke manpages via --help, etc.
So yes, the code is ready for getting merged into Linus' tree, still
there hopefully will show up some bugfixes and enhancements
while it lives in linux-next.


    Thomas
