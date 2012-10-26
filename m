Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932795Ab2JZMsn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 08:48:43 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:61429 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932731Ab2JZMsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 08:48:40 -0400
Date: Fri, 26 Oct 2012 05:48:34 -0700
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Jiri Olsa <jolsa@redhat.com>,
        Borislav Petkov <bp@amd64.org>
Subject: Re: [PATCH 4/5] perf tools: Always show CHK message when doing try-cc
Message-ID: <20121026124834.GE17937@ghostprotocols.net>
References: <1351241752-2919-1-git-send-email-namhyung@kernel.org>
 <1351241752-2919-4-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351241752-2919-4-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Oct 26, 2012 at 05:55:51PM +0900, Namhyung Kim escreveu:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> It might be useful to see what's happening behind us rather than just
> waiting few seconds during the config checking.

Which shows that we're calling it even for Documentation! :-\ Would be
good to have just one set of feature checks made...

- Arnaldo
