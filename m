Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694Ab2KGLCD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 06:02:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50613 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754285Ab2KGLCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 06:02:00 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <877gpxokqm.fsf@sejong.aot.lge.com>
References: <877gpxokqm.fsf@sejong.aot.lge.com> <25722.1352156007@warthog.procyon.org.uk> <15094.1352155791@warthog.procyon.org.uk> <4600.1352157507@warthog.procyon.org.uk>
To: Namhyung Kim <namhyung@kernel.org>
Cc: dhowells@redhat.com, mingo@kernel.org, tglx@linutronix.de,
        acme@ghostprotocols.net, bp@alien8.de, torvalds@linux-foundation.org,
        paulus@samba.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org, jolsa@redhat.com
Subject: Re: tools, perf: Fix up for x86 UAPI disintegration
Date: Wed, 07 Nov 2012 11:01:31 +0000
Message-ID: <10457.1352286091@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namhyung Kim <namhyung@kernel.org> wrote:

> I've tested your branch and it seems that it conflicts with Jiri's
> latest perf test patchset which merged into Arnaldo's perf/core branch.
> 
> Simple fix will be adding '-Iutil -I.' right after '-I$(OUTPUT)util' in
> BASIC_CFLAGS.

Should I be developing my patches on top of:

	http://git.kernel.org/?p=linux/kernel/git/acme/linux.git;a=shortlog;h=refs/heads/perf/core

rather than on tipbot's perf/core?

David
