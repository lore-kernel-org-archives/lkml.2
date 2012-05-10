Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760123Ab2EJP2I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 11:28:08 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:56565 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760100Ab2EJP2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 11:28:05 -0400
Date: Thu, 10 May 2012 17:27:51 +0200
From: Borislav Petkov <bp@amd64.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Tony Luck <tony.luck@intel.com>,
        gregkh <gregkh@linuxfoundation.org>
Subject: Re: [EDAC ABI v13 04/25] events/hw_event: Create a Hardware Events
 Report Mecanism (HERM)
Message-ID: <20120510152751.GE32700@aftab.osrc.amd.com>
References: <4FAA7649.5080606@redhat.com>
 <20120509140632.GG22737@aftab.osrc.amd.com>
 <4FAA7C1A.3020406@redhat.com>
 <20120509142456.GH22737@aftab.osrc.amd.com>
 <4FABBFAF.20809@redhat.com>
 <20120510134136.GC31257@aftab.osrc.amd.com>
 <4FABD653.7060401@redhat.com>
 <4FABD9F0.6050008@redhat.com>
 <20120510151254.GD32700@aftab.osrc.amd.com>
 <1336663210.14207.225.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336663210.14207.225.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 11:20:10AM -0400, Steven Rostedt wrote:
> On Thu, 2012-05-10 at 17:12 +0200, Borislav Petkov wrote:
> > On Thu, May 10, 2012 at 12:08:32PM -0300, Mauro Carvalho Chehab wrote:
> > > There's also another technical reason to give an acronym to the EDAC
> > > version that actually works: changeset numbers are not consistent
> > > within distributions (or other trees, like -stable - although this 60+
> > > patch series probably won't fit on -stable merging criteria).
> > >
> > > Also, this EDAC changeset 60+ patch series can't be represented by a
> > > single changeset, and requires userspace changes in order to get a
> > > proper representation model for memories.
> 
> Is this a redesign of EDAC or just a fix of it? Does this require
> userspace to use a new ABI?
> 
> > >
> > > Tagging the EDAC core version with a name helps a lot when dealing
> > > with all the unsolved bugzillas that will be closed by backporting
> > > this patch series in order to fix the serious EDAC core bug that
> > > were providing fake information to the end user for all Intel memory
> > > controllers manufactured after 2005.
> > 
> > edac_module.c:18:#define EDAC_VERSION "Ver: 2.1.0"
> > 
> > Increment that in the last patch.
> 
> If this is redesigning a subsystem and changing the ABI for userspace
> than a new name is appropriate. Much like ipchains turning into
> iptables.

But that's not the question. The subsystem is still called EDAC but
there's one patch which adds a tracepoint called trace_mc_error and this
is called needlessly a name - Hardware Events Report Mechanism - which
is only misleading and generating confusion even to its author.

Anyway, I think we solved the issue - we're going to increment
EDAC_VERSION and all is fine :-)

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
