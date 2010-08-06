Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761515Ab0HFPOX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 11:14:23 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49029 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757184Ab0HFPOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 11:14:21 -0400
Date: Fri, 6 Aug 2010 12:14:13 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Borislav Petkov <bp@amd64.org>
Cc: "fweisbec@gmail.com" <fweisbec@gmail.com>, "mingo@elte.hu" <mingo@elte.hu>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 7/9] perf: Export cpumap
Message-ID: <20100806151413.GD13780@ghostprotocols.net>
References: <1281104713-23141-1-git-send-email-bp@amd64.org>
 <1281104713-23141-8-git-send-email-bp@amd64.org>
 <20100806143912.GB13780@ghostprotocols.net>
 <20100806144939.GD21628@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100806144939.GD21628@aftab>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Aug 06, 2010 at 04:49:39PM +0200, Borislav Petkov escreveu:
> From: Arnaldo Carvalho de Melo <acme@infradead.org>
> > Is this independent of previous patches? I.e. to be applied to current
> > perf/core?

> I'm afraid not since earlier patches in the series introduce the
> toplevel Makefile that glues all the different tools/lib/* parts
> together. However, I could extract the toplevel Makefile parts and
> cpumap.c and ctype.c if you really need it now - I've been doing this so
> often lately that I could do it with my eyes closed now :o).

:-)

We need to get back at merging that series, so some patch series
installments, with say, 3 or 4 patches each, would be great.

- Arnaldo
