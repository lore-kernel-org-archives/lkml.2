Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762784Ab2EROVu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 10:21:50 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:39924 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765Ab2EROVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 10:21:48 -0400
Date: Fri, 18 May 2012 16:21:31 +0200
From: Borislav Petkov <bp@amd64.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 1/2] perf: Add persistent event facilities
Message-ID: <20120518142131.GO20215@aftab.osrc.amd.com>
References: <1332340496-21658-1-git-send-email-bp@amd64.org>
 <1332340496-21658-2-git-send-email-bp@amd64.org>
 <1337336040.573.12.camel@twins>
 <20120518110357.GH20215@aftab.osrc.amd.com>
 <1337340263.573.31.camel@twins>
 <20120518115957.GB19785@gmail.com>
 <20120518125505.GK20215@aftab.osrc.amd.com>
 <1337348267.573.37.camel@twins>
 <20120518140945.GN20215@aftab.osrc.amd.com>
 <1337350462.573.39.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337350462.573.39.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 04:14:22PM +0200, Peter Zijlstra wrote:
> On Fri, 2012-05-18 at 16:09 +0200, Borislav Petkov wrote:
> > What happens here if a second user wants to enable a second set of
> > persistent events, allocate a second set of per-CPU buffers? 
> 
> I'm not seeing the relation to VM_SHARED here.

Well, in the sense that if mmap fails in the !VM_SHARED case, I can't
enable any persistent events except the ones which are enabled and so
I need to allocate another set of resources for that second persistent
events user.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
