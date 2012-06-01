Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965929Ab2FAWp7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 18:45:59 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48142 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965841Ab2FAWp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 18:45:57 -0400
Message-ID: <4FC9461E.3080803@gmail.com>
Date: Fri, 01 Jun 2012 16:45:50 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
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
References: <1338588999-32509-1-git-send-email-acme@infradead.org>
In-Reply-To: <1338588999-32509-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/1/12 4:16 PM, Arnaldo Carvalho de Melo wrote:
> Hi Ingo,
>
> 	Please consider pulling, this is in addition to what already were in
> perf/urgent.
>
> - Arnaldo
>
> The following changes since commit 79695e1bb65ba0e21488c360a1bed6e358354aaa:
>
>    perf stat: Initialize default events wrt exclude_{guest,host} (2012-05-30 14:02:38 -0300)
>
> are available in the git repository at:
>    git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-urgent-for-mingo
>
> Arnaldo Carvalho de Melo (2):
>        perf tools: Fix make tarballs
>        perf tools: Make --version show kernel version instead of pull req tag
>
> Avik Sil (1):
>        perf tools: Fix pager on minimal-install embedded systems
>
> David Ahern (2):
>        perf script: Fix regression in callchain dso name
>        perf tool: Build fix, remove duplicate declarations
>
> Jiri Olsa (3):
>        perf symbols: Handle different endians properly during symbol load
>        perf session: Handle endianity swap on sample_id_all header data
>        perf evsel: Fix 32 bit values endianity swap for sample_id_all header

you are missing:

http://marc.info/?l=linux-kernel&m=133770186330032&w=2

