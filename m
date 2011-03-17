Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844Ab1CQMwG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 08:52:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39529 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016Ab1CQMwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 08:52:04 -0400
Date: Thu, 17 Mar 2011 13:51:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oprofile-list@lists.sourceforge.net" 
	<oprofile-list@lists.sourceforge.net>
Subject: Re: [GIT PULL] oprofile updates for v2.6.39
Message-ID: <20110317125151.GA4985@elte.hu>
References: <20110317120136.GB31407@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110317120136.GB31407@erda.amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robert Richter <robert.richter@amd.com> wrote:

> Ingo,
> 
> please pull oprofile updates for v2.6.39 (tip/perf/core):
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git core
> 
> There are only updates for the s390 architecture.
> 
> I dropped the __exit attribute patch in this pull request.
> 
> Thanks,
> 
> -Robert
> 
> 
> 
> The following changes since commit 137ee20ddd10fdc20600c389fe63edab0c39cb1a:
> 
>   Merge branch 'perf/core' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 into perf/core (2011-03-11 09:28:31 +0100)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git core
> 
> Heinz Graalfs (4):
>       oprofile: Introduce new oprofile sample add function (oprofile_add_ext_hw_sample)
>       oprofile, s390: Add support for hardware based sampling on System z processors
>       oprofile, s390: Enhance OProfile to support System zs hardware sampling feature
>       oprofile, s390: Remove hwsampler_files.c and merge it into init.c
> 
> Robert Richter (3):
>       oprofile, s390: Rework hwsampler implementation
>       oprofile, s390: Fix section mismatch of function hws_cpu_callback()
>       oprofile, s390: Cleanups
> 
>  arch/s390/oprofile/Makefile    |    2 +-
>  arch/s390/oprofile/hwsampler.c | 1256 ++++++++++++++++++++++++++++++++++++++++
>  arch/s390/oprofile/hwsampler.h |  113 ++++
>  arch/s390/oprofile/init.c      |  165 ++++++-
>  drivers/oprofile/cpu_buffer.c  |   24 +-
>  drivers/oprofile/timer_int.c   |    4 +-
>  include/linux/oprofile.h       |    7 +
>  7 files changed, 1558 insertions(+), 13 deletions(-)
>  create mode 100644 arch/s390/oprofile/hwsampler.c
>  create mode 100644 arch/s390/oprofile/hwsampler.h

Pulled, thanks a lot Robert!

	Ingo
