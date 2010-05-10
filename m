Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422Ab0EJAJ7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 20:09:59 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52005 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab0EJAJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 20:09:57 -0400
Date: Sun, 9 May 2010 21:09:44 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>,
       "Yanmin, Zhang" <yanmin_zhang@linux.intel.com>
Subject: Re: [PATCH 0/4] perf tools improvements and minor fixes
Message-ID: <20100510000944.GA19192@ghostprotocols.net>
References: <1273448369-7479-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273448369-7479-1-git-send-email-acme@infradead.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, May 09, 2010 at 08:39:25PM -0300, Arnaldo Carvalho de Melo escreveu:
> Hi Ingo,
> 
>         Please pull from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf

Oops, retracting the pull request, I found and fixed a bug on the "check
if a struct machine instance was found" patch, v2 coming shortly.
 
> Arnaldo Carvalho de Melo (4):
>   perf symbols: Consider unresolved DSOs in the dso__col_widt calculation
>   perf symbols: Check if a struct machine instance was found
>   perf session: Embed the host machine data on perf_session
>   perf report: Allow limiting the number of entries to print in callchains
