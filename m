Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753Ab0KRLye (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 06:54:34 -0500
Received: from www.tglx.de ([62.245.132.106]:46439 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954Ab0KRLyd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 06:54:33 -0500
Date: Thu, 18 Nov 2010 12:53:57 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: acme@redhat.com, mingo@elte.hu, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/2] perf: Fix compilation on gcc 4.0.2
In-Reply-To: <1290077461-12321-2-git-send-email-andi@firstfloor.org>
Message-ID: <alpine.LFD.2.00.1011181253220.2900@localhost6.localdomain6>
References: <1290077461-12321-1-git-send-email-andi@firstfloor.org> <1290077461-12321-2-git-send-email-andi@firstfloor.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Nov 2010, Andi Kleen wrote:

> From: Andi Kleen <ak@linux.intel.com>
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  tools/perf/Makefile                    |    4 ++--
>  tools/perf/util/include/linux/bitops.h |    1 +
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index d1db0f6..f4f6478 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -201,13 +201,13 @@ EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wshadow
>  EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Winit-self
>  EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wpacked
>  EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wredundant-decls
> -EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wstack-protector
> +#EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wstack-protector

Hmm, can we make that autodetected ?

Thanks,

	tglx
