Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318Ab2EYVaw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 17:30:52 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:42662 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab2EYVav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 17:30:51 -0400
Date: Fri, 25 May 2012 18:30:45 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 3/4] perf top: Fix counter name fixup when fallbacking to
 cpu-clock
Message-ID: <20120525213045.GH2336@infradead.org>
References: <1337975958-24047-1-git-send-email-acme@infradead.org>
 <1337975958-24047-4-git-send-email-acme@infradead.org>
 <4FBFEAFA.8050004@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FBFEAFA.8050004@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, May 25, 2012 at 02:26:34PM -0600, David Ahern escreveu:
> The patch I sent had:
> 
> + if (counter->name) {
> + free(counter->name);
> + counter->name = NULL;
> + counter->name = strdup(event_name(counter));
> + }
> 
> See http://lkml.indiana.edu/hypermail/linux/kernel/1205.1/00390.html

I probably messed up this one, should've put a committer note for that
stupid simplification, anyway, just setting it to NULL is enough and
less confusing.

- Arnaldo
