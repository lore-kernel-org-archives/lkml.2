Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183Ab0JMHV1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 03:21:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:41390 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab0JMHV0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 03:21:26 -0400
Subject: Re: [RFC PATCH 2/9] perf: Add ability to dump user regs
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Robert Richter <robert.richter@amd.com>,
        David Miller <davem@davemloft.net>
In-Reply-To: <1286946421-32202-3-git-send-regression-fweisbec@gmail.com>
References: <1286946421-32202-1-git-send-regression-fweisbec@gmail.com>
	 <1286946421-32202-3-git-send-regression-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 13 Oct 2010 09:20:53 +0200
Message-ID: <1286954453.29097.58.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-13 at 07:06 +0200, Frederic Weisbecker wrote:
> Add new PERF_SAMPLE_UREGS to perf sample type. This will dump the
> user space context as it was before the user entered the kernel for
> whatever reason.
> 
> This is going to be useful to bring Dwarf CFI based stack unwinding
> on top of samples.

This doesn't address any of the issues that were raised previously.

There's a reason we don't have PERF_SAMPLE_*REGS like things.

See: http://lkml.org/lkml/2010/3/3/308
