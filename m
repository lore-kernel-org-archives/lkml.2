Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446Ab2GYQNP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 12:13:15 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:62640 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755822Ab2GYQNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 12:13:10 -0400
Date: Wed, 25 Jul 2012 18:13:06 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, eranian@google.com, gorcunov@openvz.org,
        tzanussi@gmail.com, mhiramat@redhat.com, robert.richter@amd.com,
        fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com, asharma@fb.com,
        benjamin.redelings@nescent.org
Subject: Re: [PATCH 02/17] perf: Add ability to attach user level registers
 dump to sample
Message-ID: <20120725161302.GC1173@somewhere.redhat.com>
References: <1342959280-5361-1-git-send-email-jolsa@redhat.com>
 <1342959280-5361-3-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342959280-5361-3-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 22, 2012 at 02:14:25PM +0200, Jiri Olsa wrote:
> Introducing PERF_SAMPLE_REGS_USER sample type bit to trigger
> the dump of user level registers on sample. Registers we want
> to dump are specified by sample_regs_user bitmask.
> 
> Only user level registers are dumped at the moment. Meaning the
> register values of the user space context as it was before the
> user entered the kernel for whatever reason (syscall, irq,
> exception, or a PMI happening in userspace).
> 
> The layout of the sample_regs_user bitmap is described in
> asm/perf_regs.h for archs that support register dump.
> 
> This is going to be useful to bring Dwarf CFI based stack
> unwinding on top of samples.
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> Original-patch-by: Frederic Weisbecker <fweisbec@gmail.com>

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
