Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966012Ab2FAXI5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 19:08:57 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:62160 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965935Ab2FAXIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 19:08:55 -0400
Date: Fri, 1 Jun 2012 20:08:47 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Akihiro Nagai <akihiro.nagai.hw@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Avik Sil <avik.sil@linaro.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Oleg Nesterov <oleg@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>, Sunjin Yang <fan4326@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-perf-users@vger.kernel.org
Subject: Re: [GIT PULL 00/15] perf/urgent fixes
Message-ID: <20120601230847.GB19856@infradead.org>
References: <1338588999-32509-1-git-send-email-acme@infradead.org>
 <4FC9461E.3080803@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FC9461E.3080803@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jun 01, 2012 at 04:45:50PM -0600, David Ahern escreveu:
> On 6/1/12 4:16 PM, Arnaldo Carvalho de Melo wrote:
> >Jiri Olsa (3):
> >       perf symbols: Handle different endians properly during symbol load
> >       perf session: Handle endianity swap on sample_id_all header data
> >       perf evsel: Fix 32 bit values endianity swap for sample_id_all header
> 
> you are missing:
> 
> http://marc.info/?l=linux-kernel&m=133770186330032&w=2

Will go on the next round, I guess I missed it because it was "lost" in
the middle of a thread, i.e. by looking at the my mailbox it didn't
stand out because it had a "Re: " in front :-\

- Arnaldo
