Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233Ab2JAIpd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 04:45:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751993Ab2JAIpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 04:45:32 -0400
Date: Mon, 1 Oct 2012 10:45:06 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 04/12] perf tools: Convert to LIBUNWIND_SUPPORT
Message-ID: <20121001084506.GA3168@krava.brq.redhat.com>
References: <1348824728-14025-1-git-send-email-namhyung@kernel.org>
 <1348824728-14025-5-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348824728-14025-5-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 06:32:00PM +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> For building perf without libunwind, we can set NO_LIBUNWIND=1 as a
> argument of make.  It then defines NO_LIBUNWIND_SUPPORT macro for C
> code to do the proper handling.  However it usually used in a negative
> semantics - e.g. #ifndef - so we saw double negations which can be
> misleading.  Convert it to a positive form to make it more readable.
> 
> Also change NO_PERF_REGS macro to HAVE_PERF_REGS for the same reason.
> 
> Cc: Jiri Olsa <jolsa@redhat.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

Acked-by: Jiri Olsa <jolsa@redhat.com>
