Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751455Ab2JEPr7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 11:47:59 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:53420 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab2JEPr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 11:47:57 -0400
Date: Fri, 5 Oct 2012 08:47:33 -0700
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 1/5] perf trace: Setup pager before running
Message-ID: <20121005154733.GA1738@ghostprotocols.net>
References: <1349413336-26936-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349413336-26936-1-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Oct 05, 2012 at 02:02:12PM +0900, Namhyung Kim escreveu:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> Since perf trace emits lots of messages on terminal, it'd better using
> a pager.

Humm, I'm used to the strace behaviour, i.e. free flow of events, unsure
if using the pager in this specific case is right, perhaps it should be
optional.

In the TUI case, when we get to implement it there, I think that we can
go to/from pager mode, expanding callchains for pagefaults and other
events, for instance.

- Arnaldo
