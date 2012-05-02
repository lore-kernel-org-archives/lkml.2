Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884Ab2EBRex (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 13:34:53 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:40456 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755587Ab2EBRei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 13:34:38 -0400
Date: Wed, 2 May 2012 19:34:32 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Gleb Natapov <gleb@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 0/2] perf/urgent fixes
Message-ID: <20120502173432.GA13450@gmail.com>
References: <1335976024-13067-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335976024-13067-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> Hi Ingo,
> 
> 	Please consider pulling,
> 
> - Arnaldo
> 
> The following changes since commit 33ff581eddf744ea91a50d46c2f0961b375a9595:
> 
>   perf symbols: Read plt symbols from proper symtab_type binary (2012-04-20 13:34:49 -0300)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-urgent-for-mingo
> 
> for you to fetch changes up to 5622c07b4741e0afd7607bce6e850b76eeb23210:
> 
>   perf stat: Fix case where guest/host monitoring is not supported by kernel (2012-05-01 14:20:00 -0300)
> 
> ----------------------------------------------------------------
> Fixes for perf/urgent:
> 
> . Add fallback in 'perf stat' for kernels that don't support
>   perf_event_attr.exclude_guest, from Stephane Eranian.
> 
> . Fix build id cache add routine to take the size of the buffer and not of a
>   pointer, from Namhyung Kim.
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Namhyung Kim (1):
>       perf build-id: Fix filename size calculation
> 
> Stephane Eranian (1):
>       perf stat: Fix case where guest/host monitoring is not supported by kernel
> 
>  tools/perf/builtin-stat.c |   33 +++++++++++++++++++++++++++++----
>  tools/perf/util/header.c  |    2 +-
>  2 files changed, 30 insertions(+), 5 deletions(-)

Pulled, thanks Arnaldo!

	Ingo
