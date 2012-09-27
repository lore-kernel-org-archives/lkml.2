Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124Ab2I0GpE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 02:45:04 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:39315 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab2I0GpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 02:45:01 -0400
Date: Thu, 27 Sep 2012 08:44:56 +0200
From: Ingo Molnar <mingo@kernel.org>
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, alex.shi@intel.com, cpw@sgi.com, hpa@zytor.com,
        jbeulich@suse.com, mingo@elte.hu, tglx@linutronix.de,
        linux-kernel@vger.kernel.org
Subject: Re: + uv-fix-incorrect-tlb-flush-all-issue.patch added to -mm tree
Message-ID: <20120927064456.GC5996@gmail.com>
References: <20120926223058.F0844100047@wpzn3.hot.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120926223058.F0844100047@wpzn3.hot.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* akpm@linux-foundation.org <akpm@linux-foundation.org> wrote:

> The flush tlb optimization code has logical issue on UV 
> platform.  It doesn't flush the full range at all, since it 
> simply ignores its 'end' parameter (and hence also the "all" 
> indicator) in uv_flush_tlb_others() function.

In other words it's a user-space data corruptor showstopper bug 
fix for the UV platform, which should get high tip:x86/urgent 
priority, right?

It's generally useful to put such info right into the patch 
title. 'fix issue' sounds a tad too harmless.

Thanks,

	Ingo
