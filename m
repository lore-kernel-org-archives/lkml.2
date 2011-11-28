Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143Ab1K1RJx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 12:09:53 -0500
Received: from casper.infradead.org ([85.118.1.10]:57412 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913Ab1K1RJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 12:09:52 -0500
Date: Mon, 28 Nov 2011 15:09:45 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
        fweisbec@gmail.com
Subject: Re: [PATCH] perf tool: reset use_browser when compiled without NEWT
Message-ID: <20111128170945.GC12377@infradead.org>
References: <1321913788-2867-1-git-send-email-dsahern@gmail.com>
 <4ED3BDC6.2080104@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ED3BDC6.2080104@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Nov 28, 2011 at 09:58:46AM -0700, David Ahern escreveu:
> Hi Arnaldo:
> 
> didn't see this one in your queue or a response. Do you agree this is
> needed?

Well, I think we should provide a better explanation for this usecase,
i.e. the code as is will use --stdio in NO_NEWT=yes builds, but will
still offer --tui and if that is specified, will produce no output.

Perhaps it is best to either elide --tui in NO_NEWT builds or state that
the build doesn't support --tui more clearly.

Or are you seeing something else that you think needs fixing?
 
- Arnaldo
