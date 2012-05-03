Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766Ab2ECOfu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 10:35:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57709 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158Ab2ECOft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 10:35:49 -0400
Subject: Re: [PATCH 6/7] perf ui: Introduce struct perf_error_ops
From: Namhyung Kim <namhyung@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Namhyung Kim <namhyung.kim@lge.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>
In-Reply-To: <20120502190307.GF5745@infradead.org>
References: <1335761711-31403-1-git-send-email-namhyung.kim@lge.com>
	 <1335761711-31403-7-git-send-email-namhyung.kim@lge.com>
	 <20120502190307.GF5745@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 May 2012 23:35:40 +0900
Message-ID: <1336055740.1493.13.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-05-02 (수), 16:03 -0300, Arnaldo Carvalho de Melo:
> Em Mon, Apr 30, 2012 at 01:55:10PM +0900, Namhyung Kim escreveu:
> > The struct perf_error_ops is for flexible error logging.
> > We can register appropriate functions based on front-end.
> > 
> > Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
> > +
> > +	perf_error__register_functions(&perf_tui_eops);
> 
> just perf_error__register() is enough, I think.
> 

Okay, will fix.

Thanks,
Namhyung


