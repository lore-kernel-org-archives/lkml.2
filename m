Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382Ab2JZIjJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 04:39:09 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:34996 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753866Ab2JZIjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 04:39:06 -0400
Message-ID: <508A4C17.7010607@ti.com>
Date: Fri, 26 Oct 2012 14:08:47 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: <shuah.khan@hp.com>
CC: <catalin.marinas@arm.com>, <tony@atomide.com>, <olof@lixom.net>,
        <nico@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, <shuahkhan@gmail.com>
Subject: Re: [PATCH RFT] ARM64: dma-mapping: support debug_dma_mapping_error
References: <1351205220.6851.3.camel@lorien2>
In-Reply-To: <1351205220.6851.3.camel@lorien2>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 October 2012 04:17 AM, Shuah Khan wrote:
> Add support for debug_dma_mapping_error() call to avoid warning from
> debug_dma_unmap() interface when it checks for mapping error checked
> status. Without this patch, device driver failed to check map error
> warning is generated.
>
> Signed-off-by: Shuah Khan <shuah.khan@hp.com>
> ---
Looks good. Similar fix for 32bit ARM port is done in below commit.

 From 871ae57adc5ed092c1341f411514d0e8482e2611 Mon Sep 17 00:00:00 2001
From: Ming Lei <ming.lei@canonical.com>
Date: Mon, 22 Oct 2012 20:44:03 +0800
Subject: [PATCH] ARM: dma-mapping: support debug_dma_mapping_error


Regards
Santosh

