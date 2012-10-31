Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761070Ab2JaWyG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 18:54:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44287 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760753Ab2JaWyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 18:54:03 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20121024111959.GD13010@gmail.com>
References: <20121024111959.GD13010@gmail.com> <20121024103559.GB10691@gmail.com> <20121022120558.14413.78980.stgit@warthog.procyon.org.uk> <22333.1351077173@warthog.procyon.org.uk>
To: Ingo Molnar <mingo@kernel.org>
Cc: dhowells@redhat.com, tglx@linutronix.de, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/2] x86: Provide a comment in uapi/asm/hw_breakpoint.h
Date: Wed, 31 Oct 2012 22:53:41 +0000
Message-ID: <20164.1351724021@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@kernel.org> wrote:

> Just wanted to inquire about the current status of it, as I'd 
> rather not pull anything that introduces breakages and is still 
> work in progress. Once it's all sorted out I'll have a look.

Should I pull the x86 disintegration and perf fixes onto a tree derived from
tipbot since there are a lot of perf changes in there?

David
