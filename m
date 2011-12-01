Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102Ab1LAP2A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 10:28:00 -0500
Received: from fifo99.com ([67.223.236.141]:43314 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754871Ab1LAP16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 10:27:58 -0500
X-Greylist: delayed 615 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Dec 2011 10:27:58 EST
Message-ID: <1322752657.3704.2.camel@m0nster>
Subject: Re: [PATCH 1/3] ARM: msm: Remove MSM7x00 support
From: Daniel Walker <dwalker@fifo99.com>
To: David Brown <davidb@codeaurora.org>
Cc: Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Date: Thu, 01 Dec 2011 07:17:37 -0800
In-Reply-To: <1322699344-28422-1-git-send-email-davidb@codeaurora.org>
References: <1322699344-28422-1-git-send-email-davidb@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-30 at 16:29 -0800, David Brown wrote:
> -       default ARCH_MSM7X00A
> -
> -config ARCH_MSM7X00A
> -       bool "MSM7x00A / MSM7x01A"
> -       select MACH_TROUT if !MACH_HALIBUT
> -       select ARCH_MSM_ARM11
> -       select MSM_SMD
> -       select MSM_SMD_PKG3
> -       select CPU_V6
> -       select GPIO_MSM_V1
> -       select MSM_PROC_COMM
> -       select HAS_MSM_DEBUG_UART_PHYS 


Your trying to drop G1 support ? I have a G1 sitting on my desk, and I
know many other people working on the kernel have G1's .. 

Daniel

