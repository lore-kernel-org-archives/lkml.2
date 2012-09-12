Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760409Ab2ILQ04 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 12:26:56 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:56314 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758845Ab2ILQ0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 12:26:54 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6832"; a="233503953"
Date: Wed, 12 Sep 2012 09:26:52 -0700
From: David Brown <davidb@codeaurora.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 06/13] ARM: SoC: convert MSM SMP to SoC descriptor
Message-ID: <20120912162651.GA22904@codeaurora.org>
References: <1347461906-13527-1-git-send-email-arnd@arndb.de>
 <1347461906-13527-7-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347461906-13527-7-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 04:58:19PM +0200, Arnd Bergmann wrote:
> From: Marc Zyngier <marc.zyngier@arm.com>
> 
> Convert MSM SMP platforms to use the SoC descriptor to provide
> their SMP and CPU hotplug operations.
> 
> Cc: David Brown <davidb@codeaurora.org>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  arch/arm/mach-msm/board-msm8960.c |    3 +++
>  arch/arm/mach-msm/board-msm8x60.c |    7 +++++++

Stephen Boyd recently sent out a patch series that remove the non-DT
support for these two targets, which naturally generates a bunch of
conflicts.

I'm about to send out a pull request including these changes, and
after that, I'll rework this patch for the new board files, and give
it a try.

David Brown

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
