Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667Ab2GYRIR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 13:08:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24866 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756354Ab2GYRIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 13:08:16 -0400
Date: Wed, 25 Jul 2012 14:00:08 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, eranian@google.com, gorcunov@openvz.org,
        tzanussi@gmail.com, mhiramat@redhat.com, robert.richter@amd.com,
        fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com, asharma@fb.com,
        benjamin.redelings@nescent.org
Subject: Re: [PATCH 02/17] perf: Add ability to attach user level registers
 dump to sample
Message-ID: <20120725170008.GB17355@infradead.org>
References: <1342959280-5361-1-git-send-email-jolsa@redhat.com>
 <1342959280-5361-3-git-send-email-jolsa@redhat.com>
 <20120725161302.GC1173@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120725161302.GC1173@somewhere.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jul 25, 2012 at 06:13:06PM +0200, Frederic Weisbecker escreveu:
> On Sun, Jul 22, 2012 at 02:14:25PM +0200, Jiri Olsa wrote:
> > Introducing PERF_SAMPLE_REGS_USER sample type bit to trigger
> > the dump of user level registers on sample. Registers we want
> > to dump are specified by sample_regs_user bitmask.
> > 
> > Only user level registers are dumped at the moment. Meaning the
> > register values of the user space context as it was before the
> > user entered the kernel for whatever reason (syscall, irq,
> > exception, or a PMI happening in userspace).
> > 
> > The layout of the sample_regs_user bitmap is described in
> > asm/perf_regs.h for archs that support register dump.
> > 
> > This is going to be useful to bring Dwarf CFI based stack
> > unwinding on top of samples.
> > 
> > Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> > Original-patch-by: Frederic Weisbecker <fweisbec@gmail.com>
> 
> Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

Cool, Stephane, Peter, are you ok with it? Can I get your Acked-by or
even Reviewed-by?

- Arnaldo
