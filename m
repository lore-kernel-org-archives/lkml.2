Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452Ab2ALMdG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 07:33:06 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:63233 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab2ALMdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 07:33:03 -0500
MIME-Version: 1.0
In-Reply-To: <1326301493-28760-11-git-send-email-fenghua.yu@intel.com>
References: <1326301493-28760-1-git-send-email-fenghua.yu@intel.com>
	<1326301493-28760-11-git-send-email-fenghua.yu@intel.com>
Date: Thu, 12 Jan 2012 07:33:01 -0500
Message-ID: <CAMzpN2hfCCarbn+CDGrQuUaXYT29HpRd+9n0EKWvZdgLdqdAhA@mail.gmail.com>
Subject: Re: [PATCH v5 10/12] x86/mtrr/main.c: Ask the first online CPU to
 save mtrr
From: Brian Gerst <brgerst@gmail.com>
To: Fenghua Yu <fenghua.yu@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Arjan van de Ven <arjan.van.de.ven@intel.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Len Brown <len.brown@intel.com>, Randy Dunlap <rdunlap@xenotime.net>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Chen Gong <gong.chen@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>, x86 <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 12:04 PM, Fenghua Yu <fenghua.yu@intel.com> wrote:
> From: Fenghua Yu <fenghua.yu@intel.com>
>
> Ask the first online CPU to save mtrr instead of asking BSP. BSP could be
> offline when mtrr_save_state() is called.

If you can use any non-boot cpu to save the MTRRs why not just use the
current cpu?  They should all be in sync anyways.

--
Brian Gerst
