Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758817Ab1FVUHa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 16:07:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:49470 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758540Ab1FVUH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 16:07:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,407,1304319600"; 
   d="scan'208";a="16994225"
From: Andi Kleen <andi@firstfloor.org>
To: ling.ma@intel.com
Cc: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] [x86] Optimize copy-page by reducing impact from HW prefetch
References: <1308351117-32452-1-git-send-email-ling.ma@intel.com>
Date: Wed, 22 Jun 2011 13:05:41 -0700
In-Reply-To: <1308351117-32452-1-git-send-email-ling.ma@intel.com> (ling ma's
	message of "Sat, 18 Jun 2011 06:51:57 +0800")
Message-ID: <m2fwn13a3u.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ling.ma@intel.com writes:
> impact(DCU prefetcher), and simplify original code.
> The performance is improved about 15% on core2, 36% on snb respectively.
> (We use our micro-benchmark, and will do further test according to your requirment)

This doesn't make a lot of sense because neither Core-2 nor SNB use the
code path you patched. They all use the rep ; movs path

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
