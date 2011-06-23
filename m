Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760192Ab1FXBIW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 21:08:22 -0400
Received: from claw.goop.org ([74.207.240.146]:40503 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753097Ab1FXBIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 21:08:21 -0400
Message-ID: <4E03C510.5050801@goop.org>
Date: Thu, 23 Jun 2011 15:58:24 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Xen Devel <Xen-devel@lists.xensource.com>,
        Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 09/15] xen/trace: add tlb flush tracepoints
References: <cover.1308607697.git.jeremy.fitzhardinge@citrix.com>	 <4db3e32a6b21efdb4d82646816ddb1bb82ff2259.1308607697.git.jeremy.fitzhardinge@citrix.com>	 <20110621140705.GD28229@dumpdata.com>  <4E03996B.9050904@goop.org> <1308860628.531.42.camel@gandalf.stny.rr.com>
In-Reply-To: <1308860628.531.42.camel@gandalf.stny.rr.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2011 01:23 PM, Steven Rostedt wrote:
> Ouch! I didn't notice this before. Do you really need this empty event?
> Why not just use the function tracer for this? It should work.

Yes, it should, but it would be nice to present something that's
consistent with all the other tlb-related tracepoints.

> If you really need something like this, maybe I'll add a
> DEFINE_EVENT_NOARGS() that will not require arguments and can eliminate
> a lot of code that TRACE_EVENT() adds.

If you like, but only if you think its worth the effort.  The empty
string thing is a bit of an ugly hack, but its not like it makes a mess
everywhere.

    J
