Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010Ab1ASWem (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 17:34:42 -0500
Received: from mail.openrapids.net ([64.15.138.104]:49522 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754469Ab1ASWel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 17:34:41 -0500
Date: Wed, 19 Jan 2011 17:34:40 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, David Miller <davem@davemloft.net>,
        richm@oldelvet.org.uk, 609371@bugs.debian.org, ben@decadent.org.uk,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, mingo@redhat.com
Subject: Re: Bug#609371: linux-image-2.6.37-trunk-sparc64: module scsi_mod:
	Unknown relocation: 36
Message-ID: <20110119223440.GE23544@Krystal>
References: <20110118.223247.241909079.davem@davemloft.net> <20110118.232045.58440904.davem@davemloft.net> <20110119153326.GC11022@Krystal> <20110119.134047.232915743.davem@davemloft.net> <1295474423.12215.1612.camel@gandalf.stny.rr.com> <20110119222144.GC23544@Krystal> <20110119223234.GA20218@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110119223234.GA20218@merkur.ravnborg.org>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 17:34:17 up 57 days,  3:37,  4 users,  load average: 0.02, 0.04,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sam Ravnborg (sam@ravnborg.org) wrote:
> > 
> > I still wonder how a 32-bit system can generate an unaligned access trap for an
> > access to a 64-bit variable aligned on 32-bit, given that there is, by
> > definition, no 64-bit memory accesses available on the architecture ?
> 
> From the SPARC V8 manual (this is the 32 bit version of SPARC):
> 
>     Load/Store Instructions
> 
>     ...
>     Integer load and store instructions support byte (8-bit), halfword (16-bit), word
>     (32-bit), and doubleword (64-bit) accesses.
>     ...
> 
>     Alignment Restrictions
> 
>     Halfword accesses must be aligned on a 2-byte boundary, word accesses (which
>     include instruction fetches) must be aligned on a 4-byte boundary, and doubleword
>     accesses must be aligned on an 8-byte boundary. An improperly aligned
>     address causes a load or store instruction to generate a mem_address_not_aligned
>     trap.

Ah! There is always an odd case ;) Thanks!

Mathieu


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
