Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441Ab1AMDc0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 22:32:26 -0500
Received: from vms173005pub.verizon.net ([206.46.173.5]:57728 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab1AMDcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 22:32:21 -0500
Date: Wed, 12 Jan 2011 22:31:55 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <randy.dunlap@oracle.com>, linux-acpi@vger.kernel.org,
        Zhang Rui <rui.zhang@intel.com>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Zimny Lech <napohybelskurwysynom2010@gmail.com>,
        Michal Marek <mmarek@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Linus <torvalds@linux-foundation.org>
Subject: Re: on builds/randconfigs (was: [PATCH -next] thermal: depends on NET)
In-reply-to: <20110113114446.cba7a01f.sfr@canb.auug.org.au>
Message-id: <alpine.LFD.2.02.1101122226340.19754@x980>
References: <20101213163607.0b0a7c3a.sfr@canb.auug.org.au>
 <alpine.LFD.2.02.1101121257580.18873@x980>
 <20110112131800.d64c1a86.akpm@linux-foundation.org>
 <201101122224.54330.rjw@sisk.pl> <alpine.LFD.2.02.1101121654000.19754@x980>
 <20110113114446.cba7a01f.sfr@canb.auug.org.au>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Jan 2011, Stephen Rothwell wrote:

> Hi all,
> 
> On Wed, 12 Jan 2011 16:58:26 -0500 (EST) Len Brown <lenb@kernel.org> wrote:
> >
> > Kconfig select needs to be fixed so that it is not possible to
> > select something if that something's dependencies are not met.
> 
> So, should the config step fail if such a thing is attempted, or just not
> honour the "select"?
> 
> BTW, Linus asked me to investigate the alternative of having "select"
> (recursively) automatically set the dependencies if they are not already
> set ...

I expect that users want to interact only with select.

See feature X, enable feature X, and feature X
selects what is necessary to support what the user requested...

user interact with "depends-on", by comparison, is torture.
Users are not offered options unless the options
already have all of their dependencies met.
If they manually edit the config file and enable such
options, make oldconfig magically throws away their choices.
That drives people crazy.

cheers,
Len Brown, Intel Open Source Technology Center



