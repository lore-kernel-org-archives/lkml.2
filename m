Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab2FXRJa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 13:09:30 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:60252 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab2FXRJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 13:09:29 -0400
Date: Sun, 24 Jun 2012 19:09:24 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [GIT PULL] oprofile: fixes for tip/perf/urgent
Message-ID: <20120624170924.GB23001@gmail.com>
References: <20120621150820.GB24632@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120621150820.GB24632@erda.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robert Richter <robert.richter@amd.com> wrote:

> Ingo,
> 
> it's only one patch, please pull from:
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git urgent
> 
> Thanks,
> 
> -Robert
> 
> 
> The following changes since commit 6921a575c9f26f7ea274aaea3b78967810ce5513:
> 
>   Merge branch 'tip/perf/urgent-2' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace into perf/urgent (2012-06-20 14:26:58 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git urgent
> 
> Will Deacon (1):
>       oprofile: perf: use NR_CPUS instead or nr_cpumask_bits for static array
> 
>  drivers/oprofile/oprofile_perf.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Pulled, thanks Robert!

	Ingo
