Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118Ab2JFPhm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 11:37:42 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:38710 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754199Ab2JFPdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 11:33:32 -0400
Date: Sat, 6 Oct 2012 12:33:26 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] perf tools: Fix ordering with unstable tsc
Message-ID: <20121006153326.GH23354@infradead.org>
References: <1349450579-18092-1-git-send-email-dsahern@gmail.com>
 <50704B74.5090703@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <50704B74.5090703@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Oct 06, 2012 at 09:17:08AM -0600, David Ahern escreveu:
> Hi Arnaldo,
> 
> Something with your recent changes (last month) is causing perf to
> segfault with this patch. Ignore for now; I'll repost when I can
> figure it out.

Ok, I was waiting anyway for Frédéric and others to do some review on
it,

Thanks!

- Arnaldo
