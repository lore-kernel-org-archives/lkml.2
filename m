Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648Ab0JTJ4q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 05:56:46 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:35815 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab0JTJ4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 05:56:43 -0400
X-AuditID: b753bd60-a7adaba000000a18-8c-4cbebcd73c93
Message-ID: <4CBEBCD4.7030800@hitachi.com>
Date: Wed, 20 Oct 2010 18:56:36 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Mark Wielaard <mjw@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCHv11a 2.6.36-rc2-tip 12/15] 12: perf: show possible probes
 in a given file.
References: <20100825134117.5447.55209.sendpatchset@localhost6.localdomain6> <20100825134343.5447.44352.sendpatchset@localhost6.localdomain6> <20100827142144.GE5444@linux.vnet.ibm.com>
In-Reply-To: <20100827142144.GE5444@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Srikar,

(2010/08/27 23:21), Srikar Dronamraju wrote:
> Introduces -S/--show_functions option for perf-probe.
> This lists function names in a File. If no file is specified, then lists
> functions in the current running kernel.

Hmm, I think the basic functionality of this patch (I mean
functions in running kernel) could be merged separately
from this series.


> +	OPT_BOOLEAN('S', "show_functions", &params.list_functions,
> +				"Show potential probes."),
> +	OPT_CALLBACK('D', "limit_dsos", NULL, "DSO",
> +				"Limit Dsos.", opt_limit_dsos),

However, I'd rather use --funcs/-F and --dso/-D instead of
above. :)

Thank you,

-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
