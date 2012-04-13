Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266Ab2DMHt2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 03:49:28 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:42172 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756871Ab2DMHt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 03:49:27 -0400
Date: Fri, 13 Apr 2012 09:49:21 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 0/1] perf/urgent fix
Message-ID: <20120413074921.GA22132@gmail.com>
References: <1334177863-18820-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334177863-18820-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> Hi Ingo,
> 
> 	Please consider pulling.
> 
> 	Now there are 6 outstanding fixes in this branch.
> 
> - Arnaldo
> 
> The following changes since commit 31d68e7b66f168e623902e194af1e52b8cf75d71:
> 
>   perf annotate: Validate addr in symbol__inc_addr_samples (2012-04-05 19:51:14 -0300)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-urgent-for-mingo
> 
> for you to fetch changes up to 7fb0a5ee8889488f7568ffddffeb66ddeb50917e:
> 
>   perf kvm: Finding struct machine fails for PERF_RECORD_MMAP (2012-04-11 11:45:12 -0300)
> 
> ----------------------------------------------------------------
> One more fix for perf/urgent:
> 
> . Fix mmap processing for guest kernels, from Nikunj A. Dadhania.
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Nikunj A. Dadhania (1):
>       perf kvm: Finding struct machine fails for PERF_RECORD_MMAP
> 
>  tools/perf/util/session.c |   12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)

Pulled, thanks a lot Arnaldo!

	Ingo
