Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758847Ab2HVJLu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 05:11:50 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:65132 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758731Ab2HVJLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 05:11:46 -0400
Date: Wed, 22 Aug 2012 11:11:41 +0200
From: Ingo Molnar <mingo@kernel.org>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, shai@scalemp.com,
        tglx@linutronix.de, ido@wizery.com
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/platform] x86/vsmp: Use hypervisor layer for
 initialization
Message-ID: <20120822091141.GC23336@gmail.com>
References: <1344445299-22142-1-git-send-email-ido@wizery.com>
 <tip-c00679af441c5be76e195deed2c76fef65a5d102@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-c00679af441c5be76e195deed2c76fef65a5d102@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* tip-bot for Ido Yariv <ido@wizery.com> wrote:

> Commit-ID:  c00679af441c5be76e195deed2c76fef65a5d102
> Gitweb:     http://git.kernel.org/tip/c00679af441c5be76e195deed2c76fef65a5d102
> Author:     Ido Yariv <ido@wizery.com>
> AuthorDate: Wed, 8 Aug 2012 20:01:38 +0300
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Wed, 22 Aug 2012 10:48:05 +0200
> 
> x86/vsmp: Use hypervisor layer for initialization
> 
> vSMP detection and initialization could be done by
> the hypervisor layer, so set it up that way.
> 
> This cleans up vSMP initialization.
> 
> Signed-off-by: Ido Yariv <ido@wizery.com>
> Acked-by: Shai Fultheim <shai@scalemp.com>
> Link: http://lkml.kernel.org/r/1344445299-22142-1-git-send-email-ido@wizery.com
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> ---
>  arch/x86/include/asm/hypervisor.h |    1 +
>  arch/x86/include/asm/setup.h      |    7 -------
>  arch/x86/kernel/cpu/hypervisor.c  |    1 +
>  arch/x86/kernel/setup.c           |    2 --
>  arch/x86/kernel/vsmp_64.c         |   27 +++++++++++++++++----------
>  5 files changed, 19 insertions(+), 19 deletions(-)

I had to zap this commit because it breaks the build:

(.init.rodata+0x4c8): undefined reference to `x86_hyper_vsmp'

Thanks,

	Ingo
