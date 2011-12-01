Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089Ab1LASRj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 13:17:39 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:57349 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756035Ab1LASRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 13:17:38 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6547"; a="142728495"
Date: Thu, 1 Dec 2011 10:17:36 -0800
From: David Brown <davidb@codeaurora.org>
To: Daniel Walker <dwalker@fifo99.com>
Cc: David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] ARM: msm: Remove MSM7x00 support
Message-ID: <20111201181736.GA13182@huya.qualcomm.com>
References: <1322699344-28422-1-git-send-email-davidb@codeaurora.org>
 <1322752657.3704.2.camel@m0nster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322752657.3704.2.camel@m0nster>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 01, 2011 at 07:17:37AM -0800, Daniel Walker wrote:
> On Wed, 2011-11-30 at 16:29 -0800, David Brown wrote:
> > -       default ARCH_MSM7X00A
> > -
> > -config ARCH_MSM7X00A
> > -       bool "MSM7x00A / MSM7x01A"
> > -       select MACH_TROUT if !MACH_HALIBUT
> > -       select ARCH_MSM_ARM11
> > -       select MSM_SMD
> > -       select MSM_SMD_PKG3
> > -       select CPU_V6
> > -       select GPIO_MSM_V1
> > -       select MSM_PROC_COMM
> > -       select HAS_MSM_DEBUG_UART_PHYS 
> 
> 
> Your trying to drop G1 support ? I have a G1 sitting on my desk, and I
> know many other people working on the kernel have G1's .. 

If someone is willing to step up and make it work, then we can keep it
around.  My only G1 is fried, so I have no way to do anything other
than keep it compiling.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
