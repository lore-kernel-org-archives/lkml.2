Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541Ab2EPVFd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 17:05:33 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:59692 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938Ab2EPVFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 17:05:31 -0400
Date: Wed, 16 May 2012 23:05:14 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Borislav Petkov <bp@amd64.org>, Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v22] edac, ras/hw_event.h: use events to handle hw issues
Message-ID: <20120516210514.GA5801@aftab.osrc.amd.com>
References: <20120515150957.GC27806@aftab.osrc.amd.com>
 <4FB27EDC.8040001@redhat.com>
 <20120515163855.GE27806@aftab.osrc.amd.com>
 <4FB38DDF.7030009@redhat.com>
 <20120516131656.GA2202@aftab.osrc.amd.com>
 <4FB3C4D3.7000802@redhat.com>
 <20120516154708.GC2202@aftab.osrc.amd.com>
 <4FB3DB45.4060101@redhat.com>
 <20120516195951.GA5326@aftab.osrc.amd.com>
 <3908561D78D1C84285E8C5FCA982C28F192EFA27@ORSMSX104.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F192EFA27@ORSMSX104.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 08:27:24PM +0000, Luck, Tony wrote:
> > No, userspace will be doing parsing because it is the only sensible
> > thing to do. The kernel's job is to carry out enough information for
> > the user to handle the error in a way which is just enough. No more, no
> > less. It is in no f*cking way expected to make it pretty and in suitable
> > portions so that userspace can consume it.
> 
> My requirement on prettiness was just that the information useful
> to a normal system owner come first. Enough to know how serious the
> problem is, and which component is affected. The fine details must
> be in the "( ... )" part - and will generally only be of interest
> to very sophisticated users.
> 
> We've reached that goal.
> 
> Looking at the next part ... which is how to write useful analysis
> tools that study these logs. We have some common elements in trace
> records - but a there is (deliberately) plenty of scope for drivers
> to add their own customizations. If these bits are going to be
> used by the user mode tools - then they will have per-driver
> parsing code that will be tightly linked to the version of the driver.

This is exactly what I'm trying to explain - the kernel carries out the
information, userspace parses it the way it sees fit.

> Are we happy with this? Once the patch goes it, we have created an
> ABI which will be hard to change.

Yes, very true.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
