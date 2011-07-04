Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452Ab1GDWA1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 18:00:27 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59588 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333Ab1GDWA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 18:00:26 -0400
Date: Tue, 5 Jul 2011 00:00:23 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] perf, tool: Add new command "perf mem"
Message-ID: <20110704220023.GI15637@one.firstfloor.org>
References: <1309766525-14089-1-git-send-email-ming.m.lin@intel.com> <1309766525-14089-5-git-send-email-ming.m.lin@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309766525-14089-5-git-send-email-ming.m.lin@intel.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index 032ba63..221d1d8 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -372,6 +372,7 @@ BUILTIN_OBJS += $(OUTPUT)builtin-lock.o
>  BUILTIN_OBJS += $(OUTPUT)builtin-kvm.o
>  BUILTIN_OBJS += $(OUTPUT)builtin-test.o
>  BUILTIN_OBJS += $(OUTPUT)builtin-inject.o
> +BUILTIN_OBJS += $(OUTPUT)builtin-mem.o

File seems to be missing in the patch. Forgot a git add?

Also need a manpage for it.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
