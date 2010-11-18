Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239Ab0KRLP4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 06:15:56 -0500
Received: from canuck.infradead.org ([134.117.69.58]:35568 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000Ab0KRLPz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 06:15:55 -0500
Subject: Re: [PATCH 1/2] perf: Fix compilation on gcc 4.0.2
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@redhat.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
In-Reply-To: <1290077461-12321-2-git-send-email-andi@firstfloor.org>
References: <1290077461-12321-1-git-send-email-andi@firstfloor.org>
	 <1290077461-12321-2-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 18 Nov 2010 12:15:37 +0100
Message-ID: <1290078937.2109.1345.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-18 at 11:51 +0100, Andi Kleen wrote:
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

Should we be using more of the kernel makefile magic to detect this?


