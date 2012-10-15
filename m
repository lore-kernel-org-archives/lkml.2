Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075Ab2JOJ6V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 05:58:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59097 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300Ab2JOJ6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 05:58:19 -0400
Date: Mon, 15 Oct 2012 11:57:50 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH] perf ui/browser: Fix off-by-two bug on the first column
Message-ID: <20121015095749.GB1026@krava.brq.redhat.com>
References: <20121014195037.GA244@x4>
 <1350268438-5066-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350268438-5066-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2012 at 11:33:58AM +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> The commit 5395a04841fc ("perf hists: Separate overhead and baseline
> columns") makes the "Overhead" column no more the first one.  So it
> resulted in the mis-aligned column in the normal (non-diff) output.
> 
> Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

eek, missed that one ;) thanks!

Acked-by: Jiri Olsa <jolsa@redhat.com>
