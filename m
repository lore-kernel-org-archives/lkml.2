Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156Ab2BWV1q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 16:27:46 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:38717 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757137Ab2BWV1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 16:27:44 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of penberg@gmail.com designates 10.60.21.134 as permitted sender) smtp.mail=penberg@gmail.com; dkim=pass header.i=penberg@gmail.com
MIME-Version: 1.0
In-Reply-To: <1330029238.17301.3.camel@lenny>
References: <1330013922-3332-1-git-send-email-penberg@kernel.org>
	<1330025802.17301.1.camel@lenny>
	<CAOJsxLEQ0VNsTEApsWQHC4G4199xm31UkWt1n0fqh3tZVa2f8A@mail.gmail.com>
	<1330029238.17301.3.camel@lenny>
Date: Thu, 23 Feb 2012 23:27:43 +0200
X-Google-Sender-Auth: n4QXGtX31wybGwdAcehnOKyx8Os
Message-ID: <CAOJsxLEksW5Jn=xF+mFmKswRDny+ZfBTYRYUarzn_fmNcpk_OQ@mail.gmail.com>
Subject: Re: [PATCH] perf report: Add a simple GTK2-based 'perf report' browser
From: Pekka Enberg <penberg@kernel.org>
To: Colin Walters <walters@verbum.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 10:33 PM, Colin Walters <walters@verbum.org> wrote:
>> Sure. We don't want to do that for all files. Just for the ones that
>> include <gtk/gtk.h>.
>
> #pragma GCC diagnostic push
> #pragma GCC diagnostic ignored "-Wstrict-prototypes"
> #include <gtk/gtk.h>
> #pragma GCC diagnostic pop

It's cleaner to do it at Makefile level. We should do something like
sparse.git Makefile does where you can optionally specify CFLAGS for
individual source files.

                                Pekka
