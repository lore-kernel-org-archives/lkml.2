Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab1K2LwY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 06:52:24 -0500
Received: from merlin.infradead.org ([205.233.59.134]:53793 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074Ab1K2LwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 06:52:18 -0500
Date: Tue, 29 Nov 2011 09:52:05 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 12/25] perf symbols: Add nr_events to symbol_conf
Message-ID: <20111129115205.GA2244@infradead.org>
References: <1322522066-21879-1-git-send-email-acme@infradead.org>
 <1322522066-21879-13-git-send-email-acme@infradead.org>
 <4ED46336.1000207@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ED46336.1000207@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Nov 28, 2011 at 09:44:38PM -0700, David Ahern escreveu:
> On 11/28/2011 04:14 PM, Arnaldo Carvalho de Melo wrote:
> > From: Arnaldo Carvalho de Melo <acme@redhat.com>
> > Since symbol__alloc_hists need it, to avoid passing it around in many
> > functions have it in the symbol_conf struct.
> 
> I get why you want to do this, but symbol_conf seems to be an odd
> choice. This is number of events, not how to resolve or display symbols.

Well, its related to something you do per-symbol, namely annotate how
many hits per ip per event it got in its addr range.

I plan at some point look again at the symbol system to check things
like this, the filter, the need to have a map to load things, but for
now I think we can leave it there.

- Arnaldo
