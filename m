Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758270Ab2JXLUG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 07:20:06 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:53046 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644Ab2JXLUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 07:20:04 -0400
Date: Wed, 24 Oct 2012 13:19:59 +0200
From: Ingo Molnar <mingo@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/2] x86: Provide a comment in uapi/asm/hw_breakpoint.h
Message-ID: <20121024111959.GD13010@gmail.com>
References: <20121024103559.GB10691@gmail.com>
 <20121022120558.14413.78980.stgit@warthog.procyon.org.uk>
 <22333.1351077173@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22333.1351077173@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Howells <dhowells@redhat.com> wrote:

> Ingo Molnar <mingo@kernel.org> wrote:
> 
> > Just wondering, have the tools/perf/ issues been solved in your 
> > tree, are the x86 UAPI disintegration changes pullable?
> 
> Did you have a look at the set of five patches I sent?  I 
> think those should fix up perf and building tools with O=, but 
> I'm not sure whether we want the last two.  From commits 
> already made, I'm guessing that at least patch #4 should be 
> made.
> 
> Note that the disintegrate-x86 branch does not include any 
> perf fixes.  I can regenerate that with some or all of them, 
> once I know what they will be.

Just wanted to inquire about the current status of it, as I'd 
rather not pull anything that introduces breakages and is still 
work in progress. Once it's all sorted out I'll have a look.

Arnaldo, what's your take on David's perf Makefile changes?

Thanks,

	Ingo
