Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021Ab2IYLzo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 07:55:44 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:46095 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755134Ab2IYLzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 07:55:41 -0400
Date: Tue, 25 Sep 2012 13:55:36 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH] perf test: Fix build failure
Message-ID: <20120925115536.GA25264@gmail.com>
References: <1348539628-3821-1-git-send-email-namhyung@kernel.org>
 <20120925104519.GA14405@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120925104519.GA14405@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:

> Em Tue, Sep 25, 2012 at 11:20:28AM +0900, Namhyung Kim escreveu:
> > From: Namhyung Kim <namhyung.kim@lge.com>
> > 
> > The commit 6a6cd11d4e57 ("perf test: Add test for the sched tracepoint
> > format fields") added following build error:
> > 
> >   CC builtin-test.o
> > builtin-test.c: In function ‘perf_evsel__test_field’:
> > builtin-test.c:1216:6: error: variable ‘ret’ set but not used [-Werror=unused-but-set-variable]
> > builtin-test.c: In function ‘perf_evsel__tp_sched_test’:
> > builtin-test.c:1242:6: error: variable ‘ret’ set but not used [-Werror=unused-but-set-variable]
> > cc1: all warnings being treated as errors
> > make: *** [builtin-test.o] Error 1
> 
> 
> Interesting :-\
> 
> [acme@sandy linux]$ gcc --version
> gcc (GCC) 4.4.6 20120305 (Red Hat 4.4.6-4)

This caught it here:

  gcc version 4.7.0 20120507 (Red Hat 4.7.0-5) (GCC)

Thanks,

	Ingo
