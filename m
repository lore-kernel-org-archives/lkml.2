Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759651Ab2EKWbb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 18:31:31 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:36341 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932465Ab2EKWb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 18:31:28 -0400
Date: Sat, 12 May 2012 00:31:13 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Borislav Petkov <bp@amd64.org>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v.23-2] RAS: use tracepoint to handle hw issues
Message-ID: <20120511223113.GA18908@aftab.osrc.amd.com>
References: <1336683628-12954-1-git-send-email-mchehab@redhat.com>
 <1336748054-21325-1-git-send-email-mchehab@redhat.com>
 <20120511170647.GA17299@aftab.osrc.amd.com>
 <4FAD4806.2010507@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FAD4806.2010507@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 02:10:30PM -0300, Mauro Carvalho Chehab wrote:
> Well, tell me what title you want for this patch, instead of coming
> with offending comments like above, and I'll change it to match your
> desire.

Already told you but here it is again:

> Let me repeat myself:
> 
> > It should be:
> >
> > Subject: RAS: Add a tracepoint for reporting memory controller errors
> >
> > and not
> >
> > Subject: edac, ras/hw_event.h: use events to handle hw issues
> >
> > because events don't handle hw issues.
> 
> You don't use events to handle hardware issues - you use tracepoints to
> report hardware issues! And besides, "event" is so overloaded in kernel
> land that actually refraining from its use makes me keep at least a bit
> of sanity when looking at yet another header called something event.h.
> 
> Please be more precise when naming your patches.
> 
> Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
