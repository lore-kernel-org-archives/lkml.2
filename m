Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524Ab2H1RVo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 13:21:44 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:37308 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab2H1RVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 13:21:43 -0400
Message-ID: <503CFE25.2070109@nvidia.com>
Date: Tue, 28 Aug 2012 10:21:41 -0700
From: Stephen Warren <swarren@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dma: tegra: remove useless include of <mach/*.h>
References: <1346137305-7226-1-git-send-email-swarren@wwwdotorg.org>
In-Reply-To: <1346137305-7226-1-git-send-email-swarren@wwwdotorg.org>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2012 12:01 AM, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> Nothing from this file is needed, so remove the include. This helps
> single zImage work by reducing use of the mach-tegra/include/mach/
> directory.

BTW, it'd be easiest for me to take this through the Tegra tree, so it
can be consolidated with other header re-org changes.
