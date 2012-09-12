Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760603Ab2ILSvF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 14:51:05 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:52064 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226Ab2ILSvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 14:51:03 -0400
Date: Wed, 12 Sep 2012 11:50:57 -0700
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Robert Richter <robert.richter@amd.com>
Cc: David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, Ingo Molnar <mingo@kernel.org>,
        Gleb Natapov <gleb@redhat.com>, Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH 1/3] perf tool: precise mode requires exclude_guest
Message-ID: <20120912185056.GF10019@ghostprotocols.net>
References: <1347462990-29481-1-git-send-email-dsahern@gmail.com>
 <1347462990-29481-2-git-send-email-dsahern@gmail.com>
 <20120912174655.GA8285@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120912174655.GA8285@erda.amd.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Sep 12, 2012 at 07:46:55PM +0200, Robert Richter escreveu:
> On 12.09.12 09:16:28, David Ahern wrote:
> > 
> > Kernel side AMD currently ignores all exclude_* bits, so there is no impact
> > to existing IBS code paths. Robert Richter has a patch where IBS code will
> > return EINVAL if an exclude_* bit is set. When this goes in it means use
> > of :p on AMD with IBS will first fail with EINVAL (because exclude_guest
> > will be set). Then the existing fallback code within perf will unset
> > exclude_guest and try again. The second attempt will succeed if the CPU
> > supports IBS profiling.
> > 
> > Signed-off-by: David Ahern <dsahern@gmail.com>
> > Cc: Ingo Molnar <mingo@kernel.org>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Robert Richter <robert.richter@amd.com>
> > Cc: Gleb Natapov <gleb@redhat.com>
> > Cc: Avi Kivity <avi@redhat.com>
> > Link: https://lkml.org/lkml/2012/7/9/264
> > ---
> >  tools/perf/util/parse-events.c |    3 +++
> >  1 file changed, 3 insertions(+)
> 
> Acked-by: Robert Richter <robert.richter@amd.com>
> 
> I tested the patch set with AMD IBS and it works fine.

Ok, I think that in this specific patchset I can add:

Tested-by: Robert Richter <robert.richter@amd.com>
Reviewed-by: Robert Richter <robert.richter@amd.com>

Instead of an Acked-by, may I?

- Arnaldo
