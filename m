Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934183Ab2JXI6V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 04:58:21 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:53589 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933474Ab2JXI6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 04:58:19 -0400
Date: Wed, 24 Oct 2012 10:58:13 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl
Subject: Re: [PATCH] perf/x86/uncore: Handle pci_read_config_dword() error.
Message-ID: <20121024085813.GA2509@gmail.com>
References: <1351068140-13456-1-git-send-email-zheng.z.yan@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351068140-13456-1-git-send-email-zheng.z.yan@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yan, Zheng <zheng.z.yan@intel.com> wrote:

> From: "Yan, Zheng" <zheng.z.yan@intel.com>
> 
> Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
> ---
>  arch/x86/kernel/cpu/perf_event_intel_uncore.c | 43 +++++++++++++++++----------
>  1 file changed, 28 insertions(+), 15 deletions(-)

Thanks, nice fixes.

Was this runtime tested on a real Sandy Bridge-EP et al CPU so 
that we know that it does not regress anything?

Thanks,

	Ingo
