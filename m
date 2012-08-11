Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609Ab2HKSQr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2012 14:16:47 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:50504 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab2HKSQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2012 14:16:46 -0400
Date: Sat, 11 Aug 2012 15:16:41 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] perf tools: Can't find util/unwind.h
Message-ID: <20120811181641.GC3503@infradead.org>
References: <87ipcpbkvy.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ipcpbkvy.fsf@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Aug 11, 2012 at 10:47:45PM +0900, Namhyung Kim escreveu:
> Hi Arnaldo,
> 
> Your current perf/core branch fails to build like this:
> 
>   $ make
>   Makefile:494: No libunwind found. Please install libunwind >= 0.99
>       CC perf.o
>   make: *** No rule to make target `util/unwind.h', needed by `builtin-annotate.o'.  Stop.
>   
>   $ ls util/unwind*
>   ls: cannot access util/unwind*: No such file or directory
> 
> Forgot to add the files?

yeah, did some manual fixlets and forgot to add some files, since I
hadn't yet asked Ingo to pull I took the liberty of fixing it up and
force push the result, sorry about that, 'git rebase' should be fine to
get back on track.

Thanks for reporting!

- Arnaldo
