Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab0LAIWN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 03:22:13 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:60796 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884Ab0LAIWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 03:22:12 -0500
X-AuditID: b753bd60-a5730ba000000226-84-4cf605af4f25
Message-ID: <4CF605AC.2090008@hitachi.com>
Date: Wed, 01 Dec 2010 17:22:04 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Shawn Bohrer <shawn.bohrer@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCH 07/14] perf: Fix spelling mistake in probe documentation
References: <1291168642-11402-1-git-send-email-shawn.bohrer@gmail.com> <1291168642-11402-8-git-send-email-shawn.bohrer@gmail.com>
In-Reply-To: <1291168642-11402-8-git-send-email-shawn.bohrer@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/12/01 10:57), Shawn Bohrer wrote:
> Signed-off-by: Shawn Bohrer <shawn.bohrer@gmail.com>
> ---
>  tools/perf/Documentation/perf-probe.txt |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Thanks for fixing :)

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

> 
> diff --git a/tools/perf/Documentation/perf-probe.txt b/tools/perf/Documentation/perf-probe.txt
> index 62de1b7..4e23232 100644
> --- a/tools/perf/Documentation/perf-probe.txt
> +++ b/tools/perf/Documentation/perf-probe.txt
> @@ -115,7 +115,7 @@ Each probe argument follows below syntax.
>  
>  LINE SYNTAX
>  -----------
> -Line range is descripted by following syntax.
> +Line range is described by following syntax.
>  
>   "FUNC[:RLN[+NUM|-RLN2]]|SRC:ALN[+NUM|-ALN2]"
>  


-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
