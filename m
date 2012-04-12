Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934601Ab2DLSsA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 14:48:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41936 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753906Ab2DLSrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 14:47:55 -0400
Date: Thu, 12 Apr 2012 15:47:40 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, mingo@elte.hu, dsahern@gmail.com,
        penberg@kernel.org
Subject: Re: [PATCH] perf tools: fix NO_GTK2 Makefile config error
Message-ID: <20120412184740.GI16260@infradead.org>
References: <20120410103513.GA9229@quad>
 <874nspeddl.fsf@sejong.aot.lge.com>
 <CABPqkBS-MDUJBF6uBxT8heps6Kw=GYVsYHUL_oOWqB-AaiV+nw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABPqkBS-MDUJBF6uBxT8heps6Kw=GYVsYHUL_oOWqB-AaiV+nw@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Apr 12, 2012 at 10:55:48AM +0200, Stephane Eranian escreveu:
> On Thu, Apr 12, 2012 at 7:19 AM, Namhyung Kim <namhyung.kim@lge.com> wrote:
> > Hi, Stephane
> >
> > On Tue, 10 Apr 2012 12:35:13 +0200, Stephane Eranian wrote:
> >> In case the user specified NO_GTK2 on the make cmdline,
> >> compilation would fail with undefined symbol because the
> >> Makefile would not set the correct cpp variable:
> >> NO_GTK2 vs. NO_GTK2_SUPPORT.
> >>
> >> This patch renames the variable to the correct name.
> >>
> >
> > I already sent a patch for this. Please see below:
> >
> >  https://lkml.org/lkml/2012/4/11/459
> >
> Ok, I was not copied onto your post. And then the fix is buried with others
> unrelated changes, it seems. But fine with me. It just needs to be committed
> now.

Yeah, would be better to have it as a separate patch, just the fix :-\

I think I'll pick Stephane's fix, stash it in perf/urgent, as your cset
that included the build fix is only in perf/core.

Repo at:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux

- Arnaldo
