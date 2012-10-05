Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679Ab2JEMj1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 08:39:27 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:40999 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754659Ab2JEMj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 08:39:26 -0400
Date: Fri, 5 Oct 2012 14:39:22 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 33/42] perf tools: Complete tracepoint event names
Message-ID: <20121005123914.GB13172@somewhere>
References: <1349374122-27806-1-git-send-email-acme@infradead.org>
 <1349374122-27806-34-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349374122-27806-34-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2012 at 03:08:33PM -0300, Arnaldo Carvalho de Melo wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> Currently tracepoint events cannot be completed because they contain a
> colon (:) character.  The colon is considered as a word separator when
> bash completion is done - variable COMP_WORDBREAKS contains colon - so
> if a word being completed contains a colon it can be a problem.
> 
> Recent versions of bash completion provide -n switch to
> _get_comp_words_by_ref and __ltrim_colon_completions functions in order
> to resolve this issue.  Copy the latter in case not exists.

Thanks for fixing this! I scratched my head on that bug.
