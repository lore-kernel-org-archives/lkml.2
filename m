Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489Ab1ANJtw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 04:49:52 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:46345 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab1ANJtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 04:49:49 -0500
X-AuditID: b753bd60-9e55eba000000f65-3b-4d301c3a4306
Message-ID: <4D301C37.2040303@hitachi.com>
Date: Fri, 14 Jan 2011 18:49:43 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Franck Bui-Huu <vagabon.xyz@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH -perf/perf/core 3/6] perf probe: Add --funcs to show available
 functions in symtab
References: <20110113124548.22426.11201.stgit@ltc236.sdl.hitachi.co.jp>	<20110113124611.22426.10835.stgit@ltc236.sdl.hitachi.co.jp> <m3sjww7b04.fsf@gmail.com>
In-Reply-To: <m3sjww7b04.fsf@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/01/14 6:24), Franck Bui-Huu wrote:
> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> writes:
> 
> [...]
> 
>>  tools/perf/builtin-probe.c    |   29 +++++++++++++++++-
>>  tools/perf/util/probe-event.c |   67 ++++++++++++++++++++++++++++++++++++++++-
>>  tools/perf/util/probe-event.h |    1 +
>>  3 files changed, 94 insertions(+), 3 deletions(-)
> 
> "tools/perf/Documentation/perf-probe.txt" is missing ;)
> 

Oops, good catch :)

Thanks!

-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
