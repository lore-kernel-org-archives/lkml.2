Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909Ab2KSPID (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 10:08:03 -0500
Received: from merlin.infradead.org ([205.233.59.134]:46753 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab2KSPIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 10:08:01 -0500
Date: Mon, 19 Nov 2012 12:07:33 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Josh Boyer <jwboyer@gmail.com>, David Howells <dhowells@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Anton Blanchard <anton@au1.ibm.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Robert Richter <robert.richter@amd.com>, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 31/32] perf powerpc: Use uapi/unistd.h to fix build error
Message-ID: <20121119150733.GD13607@infradead.org>
References: <1353248997-30763-1-git-send-email-acme@infradead.org>
 <1353248997-30763-32-git-send-email-acme@infradead.org>
 <CA+5PVA6uj3f5f9Gp=7Zp8CE+0mP7zgCknqmkUX_ootzDxUXRcA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA6uj3f5f9Gp=7Zp8CE+0mP7zgCknqmkUX_ootzDxUXRcA@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Nov 19, 2012 at 08:29:09AM -0500, Josh Boyer escreveu:
> On Sun, Nov 18, 2012 at 9:29 AM, Arnaldo Carvalho de Melo <acme@infradead.org> wrote:
> > From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

> > Use the 'unistd.h' from arch/powerpc/include/uapi to build the perf tool.
> 
> This would work for powerpc, but at least s390x and ARM have the same
> build issue.  Why would we fix this piecemeal per-arch?
> 
> David Howells has a patch that _should_ fix it for all of them at once.
> Is there a reason that isn't going in?

David rebased his patch on top of my perf/core branch, I just tested it
and all works as expected, so I'd say he should push that branch
upstream as I can't just cherry pick some csets, it needs a merge that
involves more than just tools/perf AFAIK.

- Arnaldo
