Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab2JUQZE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 12:25:04 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:61531 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885Ab2JUQZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 12:25:02 -0400
Date: Sun, 21 Oct 2012 18:24:57 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Irina Tirdea <irina.tirdea@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: Re: [PATCH v4 1/6] perf tools: configure tmp path at build time
Message-ID: <20121021162457.GC27429@gmail.com>
References: <1350344020-8071-1-git-send-email-irina.tirdea@gmail.com>
 <1350344020-8071-2-git-send-email-irina.tirdea@gmail.com>
 <20121016151817.GB6807@ghostprotocols.net>
 <20121016164801.GA8020@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121016164801.GA8020@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Hellwig <hch@infradead.org> wrote:

> A system that doesn't have /bin/sh is fundamentally broken.

No, such a system is simply different.

> How about just creating it as a symlink in a simple unix 
> compatibility layer for Android.  That'd help with /tmp as 
> well.

That might make sense to pursue, are you volunteering for it?

Meanwhile here on earth we are making stuff work, regardless of 
dogmatic declarations.

Thanks,

	Ingo
