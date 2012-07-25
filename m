Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672Ab2GYHnM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 03:43:12 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:34241 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755202Ab2GYHnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 03:43:10 -0400
Date: Wed, 25 Jul 2012 09:43:04 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH 1/3] perf tools: Fix trace events storms due to weight
 demux
Message-ID: <20120725074304.GA27950@gmail.com>
References: <1342631456-7233-1-git-send-email-fweisbec@gmail.com>
 <20120718172941.GA7120@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120718172941.GA7120@somewhere.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> In case you wonder. This doesn't fix a regression so this is
> 3.6 material.

The newline and tracing one might be argued a regression, but 
yeah, these are probably best for v3.6.

Thanks,

	Ingo
