Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279Ab0LPPIc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 10:08:32 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:40695 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756159Ab0LPPIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 10:08:30 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6198"; a="67087437"
Message-ID: <4D0A2B6C.1000400@codeaurora.org>
Date: Thu, 16 Dec 2010 10:08:28 -0500
From: Stephen Caudle <scaudle@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.11pre) Gecko/20100922 Shredder/3.1.5pre
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: dwalker@codeaurora.org, linux-arm-msm@vger.kernel.org,
        adharmap@codeaurora.org, linux-kernel@vger.kernel.org, miltonm@bga.com,
        linux-arm-kernel@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2] [ARM] gic: Unmask private interrupts on all cores
 during IRQ enable
References: <1288820762-16077-1-git-send-email-scaudle@codeaurora.org> <20101130180718.GB8521@n2100.arm.linux.org.uk> <4CF6797A.2010807@codeaurora.org> <20101201171425.GA29347@n2100.arm.linux.org.uk> <4D0102B3.8010302@codeaurora.org> <4D0A281F.1090705@codeaurora.org> <20101216150357.GT9937@n2100.arm.linux.org.uk>
In-Reply-To: <20101216150357.GT9937@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2010 10:03 AM, Russell King - ARM Linux wrote:
> I've not changed my thoughts on this.  PPIs should not be handled by
> genirq - it just doesn't make sense for them to be.

Understood.  I will work on a patch to perf events to support the MSM
performance monitor PPI on SMP.

~Stephen

-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
