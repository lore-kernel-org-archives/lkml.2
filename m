Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936018Ab0GPIt6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 04:49:58 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:55082 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935955Ab0GPIt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 04:49:56 -0400
Subject: Re: [PATCH] kmemleak: Add support for NO_BOOTMEM configurations
From: Catalin Marinas <catalin.marinas@arm.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        "H. Peter Anvin" <hpa@zytor.com>, stable <stable@kernel.org>
In-Reply-To: <4C3F4286.3070503@kernel.org>
References: <20100715145834.20885.20341.stgit@e102109-lin.cambridge.arm.com>
	 <4C3F4286.3070503@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Fri, 16 Jul 2010 09:46:03 +0100
Message-ID: <1279269963.24890.8.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jul 2010 08:46:04.0680 (UTC) FILETIME=[5368F080:01CB24C3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-15 at 18:16 +0100, Yinghai Lu wrote:
On 07/15/2010 07:58 AM, Catalin Marinas wrote: 
> > With commits 08677214 and 59be5a8e, alloc_bootmem()/free_bootmem() and
> > friends use the early_res functions for memory management when
> > NO_BOOTMEM is enabled. This patch adds the kmemleak calls in the
> > corresponding code paths for bootmem allocations.
> >
> > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Pekka Enberg <penberg@cs.helsinki.fi>
> > Cc: Yinghai Lu <yinghai@kernel.org>
> > Cc: H. Peter Anvin <hpa@zytor.com>
> 
> should be for 2.6.34 and 2.6.35.

I only noticed it recently since we don't have NO_BOOTMEM on ARM.
Anyway, I'll cc stable@kernel.org when pushing the patch to Linus.

Should I consider your reply as an acked-by?

Thanks.

-- 
Catalin

