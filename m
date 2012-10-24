Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934708Ab2JXLNO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 07:13:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11410 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932128Ab2JXLNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 07:13:12 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20121024103559.GB10691@gmail.com>
References: <20121024103559.GB10691@gmail.com> <20121022120558.14413.78980.stgit@warthog.procyon.org.uk>
To: Ingo Molnar <mingo@kernel.org>
Cc: dhowells@redhat.com, tglx@linutronix.de, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/2] x86: Provide a comment in uapi/asm/hw_breakpoint.h
Date: Wed, 24 Oct 2012 12:12:53 +0100
Message-ID: <22333.1351077173@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@kernel.org> wrote:

> Just wondering, have the tools/perf/ issues been solved in your 
> tree, are the x86 UAPI disintegration changes pullable?

Did you have a look at the set of five patches I sent?  I think those should
fix up perf and building tools with O=, but I'm not sure whether we want the
last two.  From commits already made, I'm guessing that at least patch #4
should be made.

Note that the disintegrate-x86 branch does not include any perf fixes.  I can
regenerate that with some or all of them, once I know what they will be.

David
