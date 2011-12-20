Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419Ab1LTLN7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 06:13:59 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55982 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176Ab1LTLNy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 06:13:54 -0500
Date: Tue, 20 Dec 2011 12:11:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>
Subject: Re: [GIT PULL] oprofile updates for 3.3
Message-ID: <20111220111157.GB17430@elte.hu>
References: <20111219135910.GF16765@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111219135910.GF16765@erda.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robert Richter <robert.richter@amd.com> wrote:

> Ingo,
> 
> please pull updates for 3.3:
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git for-tip
> 
> Thanks,
> 
> -Robert
> 
> 
> 
> The following changes since commit 74eec26facadbe6dbc0621bc862892c915c4534f:
> 
>   perf tools: Add ability to synthesize event according to a sample (2011-12-12 08:44:00 -0200)
> 
> are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git for-tip
> 
> Andreas Krebbel (1):
>       oprofile, s390: Add event interface to the System z hardware sampling module
> 
> Robert Richter (1):
>       oprofile: Fix oprofile_timer_exit() breakage
> 
>  Documentation/kernel-parameters.txt |    2 +
>  arch/s390/oprofile/hwsampler.c      |    7 +-
>  arch/s390/oprofile/init.c           |  373 ++++++++++++++++++++++++++++++++---
>  arch/s390/oprofile/op_counter.h     |   23 +++
>  drivers/oprofile/oprof.h            |    1 -
>  5 files changed, 374 insertions(+), 32 deletions(-)
>  create mode 100644 arch/s390/oprofile/op_counter.h

Pulled, thanks Robert!

	Ingo
