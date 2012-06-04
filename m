Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699Ab2FDIvr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 04:51:47 -0400
Received: from mga03.intel.com ([143.182.124.21]:40919 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754066Ab2FDIvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 04:51:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="151229671"
Message-ID: <1338799997.1492.3.camel@rui.sh.intel.com>
Subject: Re: [GIT PULL] ACPI & Power Management Patches for Linux-3.5-merge
From: Zhang Rui <rui.zhang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-acpi <linux-acpi@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Mon, 04 Jun 2012 16:53:17 +0800
In-Reply-To: <4FC9B39B.403@kernel.org>
References: <4FC9B39B.403@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Len,

On 六, 2012-06-02 at 02:32 -0400, Len Brown wrote:
> 
> Amit Daniel Kachhap (5):
>       thermal: add generic cpufreq cooling implementation
>       hwmon: exynos4: move thermal sensor driver to driver/thermal directory
>       thermal: exynos5: add exynos5 thermal sensor driver support
>       thermal: exynos: register the tmu sensor with the kernel thermal layer
>       ARM: exynos: add thermal sensor driver platform data support

please drop this patch set for now.
I'm cooking up a couple of patches, most of which are making the generic
thermal layer more friendly to this patch set. So this patch set should
rather be re-based on the upcoming changes.

Sorry that I did not let you know earlier.

-rui


