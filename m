Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778Ab1BCUQj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 15:16:39 -0500
Received: from mga02.intel.com ([134.134.136.20]:33985 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051Ab1BCUQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 15:16:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,421,1291622400"; 
   d="scan'208";a="599235252"
Message-ID: <4D4B0D18.9010309@linux.intel.com>
Date: Thu, 03 Feb 2011 12:16:24 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
Organization: Intel Open Source Technology Center
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Andres Salomon <dilinger@queued.net>
CC: Grant Likely <grant.likely@secretlab.ca>, Daniel Drake <dsd@laptop.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org, sodaville@linutronix.de
Subject: Re: [sodaville] [PATCH v2 01/15] x86/e820: remove conditional early
 mapping in parse_e820_ext
References: <1292600033-12271-1-git-send-email-bigeasy@linutronix.de>	<1292600033-12271-2-git-send-email-bigeasy@linutronix.de>	<20101230083745.GC11721@angua.secretlab.ca>	<20110104130839.GA21359@www.tglx.de>	<20110114081446.GC21832@angua.secretlab.ca>	<20110114105709.GA7562@www.tglx.de>	<20110114134345.712e2e29@queued.net>	<AANLkTimyrGkqtjo99+aV+N4KcrC2_3PprpRD2tRo_NtC@mail.gmail.com>	<4D4808D2.3080701@linutronix.de>	<20110201103617.2c3aa118@debxo>	<AANLkTi=kXaD0qhpHx30tFKN92pmAESSrXE1mz_55yuQO@mail.gmail.com>	<20110203104051.12cdfbe5@queued.net>	<4D4B058F.9030208@linux.intel.com> <20110203120942.1a8fc98c@queued.net>
In-Reply-To: <20110203120942.1a8fc98c@queued.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2011 12:09 PM, Andres Salomon wrote:
> 
> Daniel has a patch set that includes the following:
> 
> 0010-OLPC-add-XO-1-rtc-driver.patch
> 
> +++ b/arch/x86/platform/olpc/olpc.c
> @@ -311,6 +311,8 @@ static int __init add_xo1_platform_devices(void)
>  {
>         struct platform_device *pdev;
> 
> +       olpc_xo1_rtc_init();
> +
>         pdev = platform_device_register_simple("xo1-rfkill", -1, NULL,
>   0);
> 
> 
> This registers a specific rtc device for XO-1 machines (using the
> CS5536 RTC).  XO-1.5 uses ACPI and a Via-based board, so the RTC device
> should be handled there automatically.  The corner case is for machines
> where the OLPC DT is enabled, but OLPC_XO1_RTC is not enabled.  We
> still need to figure out what to do in that case, but I think it's more
> appropriate to focus on getting the PM and XO1_RTC stuff upstream
> first.  As of right now, it's the *only* case.  We'll change that, by
> getting OLPC_XO1_RTC upstream.

OK, so how about "you're -----d anyway, so please don't block other
development because you haven't gotten your own driver upstream?"

	-hpa
