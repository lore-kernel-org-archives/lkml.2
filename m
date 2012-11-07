Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440Ab2KGIze (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 03:55:34 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:51028 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530Ab2KGIzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 03:55:31 -0500
X-AuditID: 9c93016f-b7c7bae000000eb7-31-509a2201e300
From: Namhyung Kim <namhyung@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: mingo@kernel.org, tglx@linutronix.de, acme@ghostprotocols.net,
        bp@alien8.de, torvalds@linux-foundation.org, paulus@samba.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, jolsa@redhat.com
Subject: Re: tools, perf: Fix up for x86 UAPI disintegration
References: <25722.1352156007@warthog.procyon.org.uk>
	<15094.1352155791@warthog.procyon.org.uk>
	<4600.1352157507@warthog.procyon.org.uk>
Date: Wed, 07 Nov 2012 17:55:29 +0900
In-Reply-To: <4600.1352157507@warthog.procyon.org.uk> (David Howells's message
	of "Mon, 05 Nov 2012 23:18:27 +0000")
Message-ID: <877gpxokqm.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Mon, 05 Nov 2012 23:18:27 +0000, David Howells wrote:
> David Howells <dhowells@redhat.com> wrote:
>
>> David Howells <dhowells@redhat.com> wrote:
>> 
>> > I've posted a revised version of my perf patches to my UAPI disintegration
>> > GIT tree.
>> 
>> Hmmm...  It seems to break some things according to Fengguang's kbuild test
>> robot.
>
> Okay.  I've fixed that.  Revised stuff pushed to the GIT tree.

I've tested your branch and it seems that it conflicts with Jiri's
latest perf test patchset which merged into Arnaldo's perf/core branch.

Simple fix will be adding '-Iutil -I.' right after '-I$(OUTPUT)util' in
BASIC_CFLAGS.

Thanks,
Namhyung
