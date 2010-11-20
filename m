Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464Ab0KTROC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 12:14:02 -0500
Received: from casper.infradead.org ([85.118.1.10]:47179 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969Ab0KTROB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 12:14:01 -0500
Date: Sat, 20 Nov 2010 15:13:34 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, a.p.zijlstra@chello.nl,
        fweisbec@gmail.com, michaele@au1.ibm.com, ianmunsi@au1.ibm.com
Subject: Re: [PATCH] perf: Change and clean up sys_perf_event_open error
 handling
Message-ID: <20101120171334.GB29710@ghostprotocols.net>
References: <1290217044-26293-1-git-send-email-cjashfor@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290217044-26293-1-git-send-email-cjashfor@linux.vnet.ibm.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Nov 19, 2010 at 05:37:24PM -0800, Corey Ashford escreveu:
> This patch makes several changes to "perf stat":
> 
> - "perf stat" will no longer go ahead and run the application when one or
> more of the specified events could not be opened.
> - Use error() and die() instead of pr_err() so that the output is more
> consistent with "perf top" and "perf record".
> - Handle permission errors in a more robust way, and in a similar way to
> "perf record" and "perf top".
> 
> In addition, the sys_perf_event_open() error handling of "perf top" and
> "perf record" is made more consistent and adds the following phrase when an
> event doesn't open (with something ther than an access or permission
> error):

Thanks, applied.

Ingo, this one is in my perf/core branch, in addition to the 3 patches I
posted yesterday.

- Arnaldo
