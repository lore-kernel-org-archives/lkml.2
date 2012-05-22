Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759399Ab2EVPg5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 11:36:57 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34848 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756809Ab2EVPg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 11:36:56 -0400
Date: Tue, 22 May 2012 12:36:48 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/2] perf tools: Always try to build libtraceevent
Message-ID: <20120522153648.GD19247@infradead.org>
References: <1337677434-4881-1-git-send-email-namhyung.kim@lge.com>
 <1337677434-4881-2-git-send-email-namhyung.kim@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337677434-4881-2-git-send-email-namhyung.kim@lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, May 22, 2012 at 06:03:54PM +0900, Namhyung Kim escreveu:
> While at it, silence annoying directory change messages.

Applied, have you seen these?

make[1]: Entering directory `/home/git/linux/tools/lib/traceevent'
make[2]: warning: jobserver unavailable: using -j1.  Add `+' to parent make rule.
make[2]: `libtraceevent.a' is up to date.

