Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833Ab1CGKTa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 05:19:30 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:49452 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754359Ab1CGKT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 05:19:28 -0500
Subject: Re: [PATCH 2/3] [ARM] perfevents: Add support for Scorpion
 performance monitors
From: Will Deacon <will.deacon@arm.com>
To: Sheetal Sahasrabudhe <sheetals@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org, jamie.iles@picochip.com,
        jean.pihet@newoldbits.com, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1299276616-12918-1-git-send-email-sheetals@codeaurora.org>
References: <1299276616-12918-1-git-send-email-sheetals@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Mar 2011 10:19:15 +0000
Message-ID: <1299493155.7349.2.camel@e102144-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sheetal,

On Fri, 2011-03-04 at 22:10 +0000, Sheetal Sahasrabudhe wrote:
> This commit adds support for performance monitors provided by
> Qualcomm Scorpion and ScorpionMP processor to perfevents.
> 
> Signed-off-by: Sheetal Sahasrabudhe <sheetals@codeaurora.org>
> ---
>  arch/arm/include/asm/perf_event.h |    2 +
>  arch/arm/kernel/perf_event.c      |   11 +
>  arch/arm/kernel/perf_event_qc.c   |  677 +++++++++++++++++++++++++++++++++++++
>  3 files changed, 690 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/kernel/perf_event_qc.c

I reviewed a few iterations of this patch off-list so you can add my
review tag (after fixing the comments and filename as pointed out by
Bryan):

Reviewed-by: Will Deacon <will.deacon@arm.com>

Will

