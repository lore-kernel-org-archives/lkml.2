Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460Ab2JCUxt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 16:53:49 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:49441 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736Ab2JCUxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 16:53:48 -0400
Message-ID: <506CA5D8.1050201@wwwdotorg.org>
Date: Wed, 03 Oct 2012 14:53:44 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: arm@kernel.org, djbw@fb.com, vinod.koul@intel.com,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH] dma: tegra: fix interrupt name issue with apb dma.
References: <1349284913-22350-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1349284913-22350-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2012 11:21 AM, Laxman Dewangan wrote:
> When watching the interrupts through /proc/interrupts,
> the name of the interrupts are blank or garbage. The
> reason is the pointer passed for devname during irq
> registration is stack and so it get changed after
> dma registration completes.
> Allocate the pointer as part of dma channel and pass
> this pointer as the devname for irq registration to
> avoid change of name.

(Dropping stable Cc; Olof/Arnd or Vinod, is it possible you could add
that into the patch description when applying this?)

Reported-by: Stephen Warren <swarren@nvidia.com>
Acked-by: Stephen Warren <swarren@nvidia.com>
