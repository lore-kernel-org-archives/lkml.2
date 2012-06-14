Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab2FNPL4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 11:11:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:55510 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151Ab2FNPLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 11:11:55 -0400
Date: Thu, 14 Jun 2012 12:11:42 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Dmitry Antipov <dmitry.antipov@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jim Cromie <jim.cromie@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [GIT PULL 0/3] perf/urgent fixes
Message-ID: <20120614151142.GD9449@infradead.org>
References: <1339601367-17834-1-git-send-email-acme@infradead.org>
 <20120614100710.GB19531@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120614100710.GB19531@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jun 14, 2012 at 12:07:10PM +0200, Ingo Molnar escreveu:
> * Arnaldo Carvalho de Melo <acme@infradead.org> wrote:
> Hm, fails to build here:
> 
>     CC util/parse-events-bison.o
> util/parse-events.l: In function ‘__value’:
> util/parse-events.l:18:10: error: ‘PE_ERROR’ undeclared (first 
> use in this function)
> util/parse-events.l:18:10: note: each undeclared identifier is 
> reported only once for each function it appears in
> util/parse-events.l:20:2: error: ‘parse_events_lval’ undeclared 
> (first use in this function)
> util/parse-events.l: In function ‘value’:
> util/parse-events.l:26:42: error: ‘PE_VALUE’ undeclared (first 
> use in this function)
> util/parse-events.l: In function ‘raw’:
> util/parse-events.l:31:44: error: ‘PE_RAW’ undeclared (first use 
> in this function)
> util/parse-events.l: In function ‘str’:
> 
> stock Fedora 17 install. 25f42985825d builds fine.

Oops, fixing...

- Arnaldo
