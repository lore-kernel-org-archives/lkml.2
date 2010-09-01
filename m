Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091Ab0IAIKf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 04:10:35 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:56212 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab0IAIKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 04:10:31 -0400
Date: Wed, 1 Sep 2010 10:10:13 +0200
From: Borislav Petkov <bp@amd64.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "acme@infradead.org" <acme@infradead.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Petkov, Borislav" <Borislav.Petkov@amd.com>
Subject: Re: [RFC PATCH 5/9] perf: Move trace stuff into tools/lib/trace
Message-ID: <20100901081013.GA23512@aftab>
References: <1281104713-23141-1-git-send-email-bp@amd64.org>
 <1281104713-23141-6-git-send-email-bp@amd64.org>
 <1283300144.1377.864.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283300144.1377.864.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>
Date: Tue, Aug 31, 2010 at 08:15:44PM -0400

> On Fri, 2010-08-06 at 16:25 +0200, Borislav Petkov wrote:
> > From: Borislav Petkov <borislav.petkov@amd.com>
> > 
> > Move tracing stuff into tools/lib/trace and rewire it back into perf.
> > Add a top-level Makefile which selects between targets depending
> > on the tool we want to build.
> > 
> > Also, add a Makefile.lib for common facilities used by all the
> > Makefiles. While at it, make sure objects output directory using O=
> > exists.
> > 
> > Finally, rename trace/util.h to trace/trace-util.h so as not to
> > conflict
> > with perf's util.h.
> > 
> > Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> > --- 
> 
> 
> I'll merge this patch into my tree, and that should make it easier for
> you.

Yeah, that's cool. FYI, Arnaldo wanted to have that toplevel-Makefile
thing too (tools/Makefile) so there might be some conflicts depending on
how far he is.

Thanks Steven.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
