Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209Ab2ERPZT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 11:25:19 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:40310 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730Ab2ERPZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 11:25:14 -0400
Date: Fri, 18 May 2012 17:24:56 +0200
From: Borislav Petkov <bp@amd64.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@amd64.org>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] perf: Add persistent event facilities
Message-ID: <20120518152456.GQ20215@aftab.osrc.amd.com>
References: <1337336040.573.12.camel@twins>
 <20120518110357.GH20215@aftab.osrc.amd.com>
 <1337340263.573.31.camel@twins>
 <20120518115957.GB19785@gmail.com>
 <20120518125505.GK20215@aftab.osrc.amd.com>
 <1337348267.573.37.camel@twins>
 <20120518140945.GN20215@aftab.osrc.amd.com>
 <1337350462.573.39.camel@twins>
 <20120518142131.GO20215@aftab.osrc.amd.com>
 <1337351857.573.47.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337351857.573.47.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 04:37:37PM +0200, Peter Zijlstra wrote:
> > > I'm not seeing the relation to VM_SHARED here.
> > 
> > Well, in the sense that if mmap fails in the !VM_SHARED case, I can't
> > enable any persistent events except the ones which are enabled and so
> > I need to allocate another set of resources for that second persistent
> > events user.
> 
> Right, well, you could actually allow operations on the fd, just not a
> second mapping :-)
> 
> Anyway.. I'd push that error back to the user. If they need a second
> set, let them create it.
> 
> Do you really need multiple consumers for your MCE stuff? If so, what
> would be the problem of using VM_SHARED?

Nah, for MCE I'm fine with RO buffers, simple :-).

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
