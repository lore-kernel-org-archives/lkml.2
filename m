Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab0JMHWc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 03:22:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:41421 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab0JMHWb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 03:22:31 -0400
Subject: Re: [RFC PATCH 3/9] perf: Add ability to dump part of the user
 stack
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
        Robert Richter <robert.richter@amd.com>
In-Reply-To: <1286946421-32202-4-git-send-regression-fweisbec@gmail.com>
References: <1286946421-32202-1-git-send-regression-fweisbec@gmail.com>
	 <1286946421-32202-4-git-send-regression-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 13 Oct 2010 09:22:17 +0200
Message-ID: <1286954537.29097.59.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-13 at 07:06 +0200, Frederic Weisbecker wrote:
> +++ b/include/linux/perf_event.h
> @@ -227,6 +227,12 @@ struct perf_event_attr {
>         __u32                   bp_type;
>         __u64                   bp_addr;
>         __u64                   bp_len;
> +
> +       __u64                   __reserved_2;
> +       __u64                   __reserved_3;
> +
> +       __u32                   ustack_dump_size;
> +       __u32                   __reserved_4;
>  }; 

Why add those two __u64 fields?
