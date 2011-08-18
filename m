Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152Ab1HRRIQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 13:08:16 -0400
Received: from wondertoys-mx.wondertoys.net ([206.117.179.246]:44908 "EHLO
	labridge.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751491Ab1HRRIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 13:08:15 -0400
Subject: Re: [PATCH 5/6] MAINTAINERS: Fix list of perf events source files
From: Joe Perches <joe@perches.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Geunsik Lim <geunsik.lim@samsung.com>,
        Jiri Kosina <trivial@kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <1313686204-30295-6-git-send-email-acme@infradead.org>
References: <1313686204-30295-1-git-send-email-acme@infradead.org>
	 <1313686204-30295-6-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Aug 2011 10:08:12 -0700
Message-ID: <1313687292.32547.90.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-18 at 13:50 -0300, Arnaldo Carvalho de Melo wrote:
> From: Geunsik Lim <geunsik.lim@samsung.com>
> Recent changes made kernel/perf_event.c be split and moved to
> kernel/events/.
[]
> diff --git a/MAINTAINERS b/MAINTAINERS
[]
> @@ -4971,7 +4971,7 @@ M:	Paul Mackerras <paulus@samba.org>
[]
> -F:	kernel/perf_event*.c
> +F:	kernel/events/*

Trivia...

MAINTAINERS pattern matching in get_maintainer uses

directory/	to match all files and files in subdirectories
directory/*	to match only the files in the directory
		but no files in any subdirectory

This should probably be kernel/events/ so any
future subdirectory files are also included.

There is no effective difference today because
no subdirectories of kernel/event/ exist.


