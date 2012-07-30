Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab2G3OQg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 10:16:36 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51798 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086Ab2G3OQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 10:16:31 -0400
Date: Mon, 30 Jul 2012 15:16:17 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Jason Wessel <jason.wessel@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Colin Cross <ccross@android.com>, John Stultz <john.stultz@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        kernel-team@android.com, kgdb-bugreport@lists.sourceforge.net
Subject: Re: [PATCH 10/11] ARM: versatile: Make able to use UART ports for
	KGDB FIQ debugger
Message-ID: <20120730141617.GK6802@n2100.arm.linux.org.uk>
References: <20120730115719.GA5742@lizard> <1343649500-18491-10-git-send-email-anton.vorontsov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343649500-18491-10-git-send-email-anton.vorontsov@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2012 at 04:58:19AM -0700, Anton Vorontsov wrote:
> diff --git a/arch/arm/mach-versatile/include/mach/irqs.h b/arch/arm/mach-versatile/include/mach/irqs.h
> index bf44c61..fcd2a95 100644
> --- a/arch/arm/mach-versatile/include/mach/irqs.h
> +++ b/arch/arm/mach-versatile/include/mach/irqs.h
> @@ -26,6 +26,7 @@
>   *  held within platform.h
>   */
>  #define IRQ_VIC_START		0
> +#define FIQ_START		IRQ_VIC_START

No.  We want to ultimately get rid of FIQ_START.
