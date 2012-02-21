Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505Ab2BUO74 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 09:59:56 -0500
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:33390 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755448Ab2BUO7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 09:59:54 -0500
Date: Tue, 21 Feb 2012 15:59:43 +0100
From: Borislav Petkov <bp@amd64.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Tony Luck <tony.luck@intel.com>,
        edac-devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: RAS trace event proto
Message-ID: <20120221145943.GB15515@aftab>
References: <20120220145920.GB5728@aftab>
 <4F438CE9.7080807@redhat.com>
 <20120221141231.GA15515@aftab>
 <1329835698.25686.60.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329835698.25686.60.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 21, 2012 at 09:48:18AM -0500, Steven Rostedt wrote:
> On Tue, 2012-02-21 at 15:12 +0100, Borislav Petkov wrote:
> 
> > > Also, folding everything into just one string prevents (or make hard) the usage of
> > > the perf filters, for example, to filter only the errors at the memory controller 1.
> > 
> > Huh, because you can't grep through the trace anymore...?
> > 
> 
> I believe Mauro is talking about the tracing filters used by both perf
> and ftrace that lets you ignore trace events when the contents of the
> event does not match the filter. This is filtering out events before
> they go to the buffer.

Oh ok, in that case we could filter the errors - if needed - before they
get even reported. I say "if needed" because normally we want to collect
all hw errors in the trace, IMHO.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
