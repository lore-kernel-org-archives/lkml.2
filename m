Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657Ab0FGLuP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 07:50:15 -0400
Received: from adelie.canonical.com ([91.189.90.139]:51485 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558Ab0FGLuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 07:50:14 -0400
Subject: Re: [PATCH] perf probe: add kernel source path option
From: Chase Douglas <chase.douglas@canonical.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>, Masami Hiramatsu <mhiramat@redhat.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1275870125-25666-1-git-send-email-chase.douglas@canonical.com>
References: <1275870125-25666-1-git-send-email-chase.douglas@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Jun 2010 07:49:59 -0400
Message-ID: <1275911399.7261.2.camel@cndougla-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-06-06 at 20:22 -0400, Chase Douglas wrote:
> The probe plugin requires access to the source code for some operations.
> The source code must be in the exact same location as specified by the
> DWARF tags, but sometimes the location is an absolute path that cannot
> be replicated by a normal user. This change adds the -s|--source option
> to allow the user to specify the root of the kernel source tree.
> 
> Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
> ---
>  tools/perf/Documentation/perf-probe.txt |    4 ++
>  tools/perf/builtin-probe.c              |    2 +
>  tools/perf/util/probe-finder.c          |   56 +++++++++++++++++++++++++++++-
>  tools/perf/util/symbol.h                |    1 +
>  4 files changed, 61 insertions(+), 2 deletions(-)

Please disregard this patch. It is based on the 2.6.34 kernel and I
forgot to rebase it on the latest perf code. I have a newer patch I will
be sending out shortly.

Thanks,

-- Chase

