Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab0KDJ7K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 05:59:10 -0400
Received: from walscop001.walsimou.com ([82.228.201.70]:23318 "EHLO
	bekkor.walsimou.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089Ab0KDJ7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 05:59:09 -0400
X-Greylist: delayed 324 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Nov 2010 05:59:08 EDT
Message-ID: <4CD282A7.9080204@embtoolkit.org>
Date: Thu, 04 Nov 2010 10:53:43 +0100
From: Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.15) Gecko/20101030 Icedove/3.0.10
MIME-Version: 1.0
To: Kyungmin Park <kyungmin.park@samsung.com>
CC: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, kgene@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: Fix HAVE_S3C2410_WATCHDOG warnings
References: <20101104081633.GA27129@july>
In-Reply-To: <20101104081633.GA27129@july>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2010 09:16 AM, Kyungmin Park wrote:
> Fix build warnings
> warning: (ARCH_S3C64XX && <choice> && WATCHDOG || ARCH_S5P64X0 && <choice> && WATCHDOG || ARCH_S5P6442 && <choice> && WATCHDOG || ARCH_S5PC100 && <choice> || ARCH_S5PV210 && <choice> || ARCH_S5PV310 && <choice> || MACH_SMDK6410 && ARCH_S3C64XX) selects HAVE_S3C2410_WATCHDOG which has unmet direct dependencies (WATCHDOG)
>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>   
Kyungmin Park,
The same warning appears when I2C is not selected.

Best regards,
AWG

