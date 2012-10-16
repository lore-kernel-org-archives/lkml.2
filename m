Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065Ab2JPPWD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 11:22:03 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:48572 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754973Ab2JPPWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 11:22:01 -0400
Date: Tue, 16 Oct 2012 08:21:53 -0700
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Irina Tirdea <irina.tirdea@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: Re: [PATCH v4 3/6] perf tools: add --addr2line command line option
Message-ID: <20121016152153.GD6807@ghostprotocols.net>
References: <1350344020-8071-1-git-send-email-irina.tirdea@gmail.com>
 <1350344020-8071-4-git-send-email-irina.tirdea@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350344020-8071-4-git-send-email-irina.tirdea@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Oct 16, 2012 at 02:33:37AM +0300, Irina Tirdea escreveu:
> From: Irina Tirdea <irina.tirdea@intel.com>
> 
> When analyzing data recorded on a target with a different architecture
> than the host, we must use addr2line from the toolchain for that
> architecture.
> 
> Add a command line option to allow setting addr2line at runtime.

You're doing two things here:

1. Adding --addr2line

2. fixing a bug for unresolved symbols

Please try not to do that, instead provide two patches, one addressing
each issue.

Furthermore, Namhyung fixed #2 already:

commit a2c1311c4cbd47a087e95be18fee79ead3d0744b
Author: Namhyung Kim <namhyung.kim@lge.com>
Date:   Mon Oct 15 12:39:42 2012 +0900

    perf tools: Fix segfault when using srcline sort key

- Arnaldo
