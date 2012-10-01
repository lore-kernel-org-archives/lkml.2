Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524Ab2JAO1o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 10:27:44 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:33549 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447Ab2JAO1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 10:27:42 -0400
Date: Mon, 1 Oct 2012 07:27:37 -0700
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>, Irina Tirdea <irina.tirdea@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        David Ahern <dsahern@gmail.com>, Pekka Enberg <penberg@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Irina Tirdea <irina.tirdea@intel.com>
Subject: Re: [PATCH v2 3/4] perf annotate: configure objdump path at compile
 time
Message-ID: <20121001142737.GC9829@ghostprotocols.net>
References: <1348428446-28245-1-git-send-email-irina.tirdea@gmail.com>
 <1348428446-28245-4-git-send-email-irina.tirdea@gmail.com>
 <1348578539.1877.40.camel@leonhard>
 <CANg8OW+u=dsi=5Y04ka0D=VLKEUELAo1L3mkWhs5mOqTS4c1jA@mail.gmail.com>
 <87d318w7u9.fsf@sejong.aot.lge.com>
 <CANg8OWLR64RQYMwi=vx78tWBfcML4CPrerXV3nE+ngYkJ3Ru=A@mail.gmail.com>
 <87haqjvc6f.fsf@sejong.aot.lge.com>
 <20121001072154.GA17143@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121001072154.GA17143@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Oct 01, 2012 at 09:21:54AM +0200, Ingo Molnar escreveu:
> * Namhyung Kim <namhyung@kernel.org> wrote:
> > What I'm thinking is that perf can try to find cross-built binutils
> > when it detects perf.data file is came from other
> > machine/architecture. Fortunately perf_session_env was added
> > recently and it has the arch information from the file so we can use
> > it to find the path.

> > Following patch is a proof-of-concept patch and only build tested.
> > What do you think?  Could you play with it for some time? :)

> This is a pretty clever idea - much better than hard-coding 
> architecture details at build time.

Indeed, great idea!

- Arnaldo
