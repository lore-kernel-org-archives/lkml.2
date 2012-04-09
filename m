Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017Ab2DIRWs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 13:22:48 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:54016 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901Ab2DIRWr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 13:22:47 -0400
MIME-Version: 1.0
In-Reply-To: <1333940074-19052-1-git-send-email-namhyung.kim@lge.com>
References: <1333940074-19052-1-git-send-email-namhyung.kim@lge.com>
Date: Mon, 9 Apr 2012 19:22:46 +0200
Message-ID: <CAFTL4hz19R9heUjEBZMhweTHRuPzr-qf0hN=FLB9eRd-R9cPgg@mail.gmail.com>
Subject: Re: [PATCH 0/7] trace-cmd: Small fixes and cleanups on libparsevent
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/4/9 Namhyung Kim <namhyung.kim@lge.com>:
> Hi, all
>
> This is a couple of small changes that I found during the flight back to
> Korea :). While I'm not finished with reading the whole code, I send what
> I have now in the hope that it'd help Frederic's unification work somewhat.
> More might come later as I read the remaining parts.
>
> The patch 01 is a workaround to build trace-cmd without installing swig
> since I don't have an internet access at that time, so it's independent
> to others and can go separately.
>
> Thanks.
>
>
> Namhyung Kim (7):
>  trace-cmd: Add NO_PYTHON option for Makefile
>  parse-events: Fix printk_cmp()
>  parse-events: Introduce extend_token()
>  parse-events: Handle strdup failure cases
>  parse-events: Fix a possible memory leak
>  parse-events: Handle realloc() failure path
>  parse-events: Fix a possibly wrong memory dereference
>
>  Makefile       |    2 +
>  parse-events.c |  168 +++++++++++++++++++++++++++++++++++++++----------------
>  2 files changed, 121 insertions(+), 49 deletions(-)

Nice! I guess this should probably go into trace-cmd tree and then we
backport later to the lib?
Or I can carry them myself in the lib.

> --
> 1.7.7.6
>
