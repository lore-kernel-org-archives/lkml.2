Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932970Ab2EWRPR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 13:15:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13823 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944Ab2EWRPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 13:15:15 -0400
Date: Wed, 23 May 2012 13:15:08 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Steven Rostedt <srostedt@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Perf build failure in v3.4-4842-g61011677
Message-ID: <20120523171508.GG1143@zod.bos.redhat.com>
References: <20120523141359.GE1143@zod.bos.redhat.com>
 <20120523143304.GF1143@zod.bos.redhat.com>
 <20120523171314.GA1687@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120523171314.GA1687@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 02:13:14PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Wed, May 23, 2012 at 10:33:05AM -0400, Josh Boyer escreveu:
> > OK, seems Steven fixed the trace-event-python.c file with commit
> > aaf045f7233, but missed the perl one.  This patch seems to fixup the
> > errors.
> 
> I reported this to Frédéric, that fixed it, I merged on my perf/core
> branch, that Ingo already pulled, thanks anyway,

Oh good.  And that's headed to Linus' tree soon?

josh
