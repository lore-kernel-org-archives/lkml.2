Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763Ab2IBUbC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 16:31:02 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:33457 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754511Ab2IBUbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 16:31:00 -0400
MIME-Version: 1.0
In-Reply-To: <503E4A58.5000000@gmail.com>
References: <CANg8OW+q0VumrJrQL57gecO0W0TrpB_WgspKhM-GeiPEdiSPDQ@mail.gmail.com>
 <503E4A58.5000000@gmail.com>
From: Irina Tirdea <irina.tirdea@gmail.com>
Date: Sun, 2 Sep 2012 23:30:39 +0300
Message-ID: <CANg8OWLo88Hjyw2hyRmkeWy3T=bt8_bEM=Hiji6-YEbhGT60HQ@mail.gmail.com>
Subject: Re: [PATCH 12/13] perf tools: replace on_exit with atexit
To: David Ahern <dsahern@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Bernhard's patch implements on_exit. Why not go that route?
>
> The exit functions need the commands status to know whether to attempt to
> process records. See: https://lkml.org/lkml/2012/8/26/123
>
> Processing records on non-0 exit causes a segfault as the session has been
> deleted.

I was trying to avoid as much as possible adding implementations for
functions in perf. Considering the patch you mentioned and the need to
know the exit status, looks like Bernhard's solution is the best
approach in this case. I will use his on_exit wrapper and drop this
patch.

Thanks,
Irina
