Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302Ab2JBMww (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 08:52:52 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:42392 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147Ab2JBMwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 08:52:51 -0400
Subject: Re: [PATCH v2] tools lib traceevent: Fix missed freeing of subargs
 in free_arg() in filter
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
In-Reply-To: <1349137408.22822.135.camel@gandalf.local.home>
References: <1349137408.22822.135.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Oct 2012 21:52:45 +0900
Message-ID: <1349182365.1538.0.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-10-01 (월), 20:23 -0400, Steven Rostedt:
> Some of args were missed in free_args(), as well as subargs.
> That is args like FILTER_ARG_NUM have left and right pointers to
> other args that also need to be freed.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Reviewed-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung


