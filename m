Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875Ab2AQPhZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 10:37:25 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33955 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384Ab2AQPhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 10:37:24 -0500
Message-ID: <4F1595AE.3070805@gmail.com>
Date: Tue, 17 Jan 2012 08:37:18 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH -tip v4 1/5] perf-script: unify the expressions indicate
 "unknown"
References: <20120116052146.2485.48349.stgit@linux3> <20120116052210.2485.80894.stgit@linux3>
In-Reply-To: <20120116052210.2485.80894.stgit@linux3>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/15/2012 10:22 PM, Akihiro Nagai wrote:
> perf-script uses various expressions to indicate "unknown".
> It is unfriendly for user scripts to parse it. So, this patch unifies
> the expressions to "[unknown]".
> 
> Changes in v3:
>  - unify all expressions to [unknown]
> 
> Changes in v2:
>  - add this patch
> 

Reviewed-by: David Ahern <dsahern@gmail.com>
