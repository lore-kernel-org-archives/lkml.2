Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751444Ab2BQGEQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 01:04:16 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:35032 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040Ab2BQGEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 01:04:15 -0500
X-AuditID: b753bd60-9825fba00000359c-cb-4f3deddc7bd9
X-AuditID: b753bd60-9825fba00000359c-cb-4f3deddc7bd9
Message-ID: <4F3DEDD7.6090804@hitachi.com>
Date: Fri, 17 Feb 2012 15:04:07 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:10.0.1) Gecko/20120208 Thunderbird/10.0.1
MIME-Version: 1.0
To: Danny Kukawka <danny.kukawka@bisect.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Danny Kukawka <dkukawka@suse.de>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>, Jovi Zhang <bookjovi@gmail.com>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH] tools/perf/util/probe-event.c included string.h twice
References: <1329400459-31570-1-git-send-email-danny.kukawka@bisect.de>
In-Reply-To: <1329400459-31570-1-git-send-email-danny.kukawka@bisect.de>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/02/16 22:54), Danny Kukawka wrote:
> tools/perf/util/probe-event.c included 'string.h' twice,
> remove the duplicate.

Right, since perf-defined string util functions(in util/string.c)
are declared in util.h, not string.h.

> 
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitahi.com>

Thank you!

> ---
>  tools/perf/util/probe-event.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
> index 29cb654..8ce8356 100644
> --- a/tools/perf/util/probe-event.c
> +++ b/tools/perf/util/probe-event.c
> @@ -34,7 +34,6 @@
>  
>  #include "util.h"
>  #include "event.h"
> -#include "string.h"
>  #include "strlist.h"
>  #include "debug.h"
>  #include "cache.h"


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
