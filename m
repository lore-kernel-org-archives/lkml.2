Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222Ab0CYRms (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 13:42:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18851 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751488Ab0CYRmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 13:42:46 -0400
Message-ID: <4BABA088.2000405@redhat.com>
Date: Thu, 25 Mar 2010 13:42:32 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc11 Thunderbird/3.0.3
MIME-Version: 1.0
To: Andrea Gelmini <andrea.gelmini@gelma.net>
CC: linux-doc@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/16] Tools perf probe-finder.c: duplicated include
References: <1269537767-7553-1-git-send-email-andrea.gelmini@gelma.net> <1269537767-7553-14-git-send-email-andrea.gelmini@gelma.net>
In-Reply-To: <1269537767-7553-14-git-send-email-andrea.gelmini@gelma.net>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrea,

Andrea Gelmini wrote:
> tools/perf/util/probe-finder.c: string.h is included more than once.

Would you mean that <string.h> and "string.h" are duplicated? 
If so, NAK, sorry. Those are different, <string.h> is for
/usr/include/string.h, and "string.h" is for tools/perf/util/string.h.

Thank you,

> 
> Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
> ---
>  tools/perf/util/probe-finder.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
> index 1e6c65e..682eb37 100644
> --- a/tools/perf/util/probe-finder.c
> +++ b/tools/perf/util/probe-finder.c
> @@ -32,7 +32,6 @@
>  #include <stdarg.h>
>  #include <ctype.h>
>  
> -#include "string.h"
>  #include "event.h"
>  #include "debug.h"
>  #include "util.h"

-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
