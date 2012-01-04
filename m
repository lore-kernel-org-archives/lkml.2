Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab2ADAle (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 19:41:34 -0500
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:48120 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754643Ab2ADAlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 19:41:32 -0500
From: Kevin Hilman <khilman@ti.com>
To: Colin Cross <ccross@android.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@lists.linux-foundation.org, Len Brown <len.brown@intel.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Trinabh Gupta <g.trinabh@gmail.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        linux-omap@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 0/3] coupled cpuidle state support
Organization: Texas Instruments, Inc.
References: <1324426147-16735-1-git-send-email-ccross@android.com>
Date: Tue, 03 Jan 2012 16:41:27 -0800
In-Reply-To: <1324426147-16735-1-git-send-email-ccross@android.com> (Colin
	Cross's message of "Tue, 20 Dec 2011 16:09:04 -0800")
Message-ID: <87sjjw70zs.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Colin Cross <ccross@android.com> writes:


> This patch series implements an alternative solution, where each
> cpu will wait in the WFI state until all cpus are ready to enter
> a coupled state, at which point the coupled state function will
> be called on all cpus at approximately the same time.

This looks great, and is certainly preferred to hotplug IMO.

[...]

> None of the platforms I work with have an SMP idle implementation
> upstream, so I can't easily show a patch that converts a platform
> from hotplug governor to coupled cpuidle states.  

Basic OMAP4 CPUidle support is in now queued for v3.3 (see omap4
branch Tony's tree[1].)  

Can you (or Santosh) send a patch that adds coupled support to that
driver so it can see some broader testing on OMAP4?

Thanks,

Kevin

[1] git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap.git
