Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab2LJNoy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 08:44:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51726 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753328Ab2LJNov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 08:44:51 -0500
Date: Mon, 10 Dec 2012 14:44:34 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>, namhyung.kim@lge.com
Subject: Re: [PATCH 1/4] perf hists: Exchange order of comparing items when
 collapsing hists
Message-ID: <20121210134434.GA6416@krava.brq.redhat.com>
References: <1355128197-18193-1-git-send-email-namhyung@kernel.org>
 <1355128197-18193-2-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355128197-18193-2-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 05:29:54PM +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> When comparing entries for collapsing put the given entry first, and
> then the iterated entry.  This is not the case of hist_entry__cmp()
> when called if given sort keys don't require collapsing.  So change
> the order for the sake of consistency.  It will be required for
> matching and/or linking multiple hist entries.
> 
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Stephane Eranian <eranian@google.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

Acked-by: Jiri Olsa <jolsa@redhat.com>
