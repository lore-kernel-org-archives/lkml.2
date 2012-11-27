Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756960Ab2K0EoZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 23:44:25 -0500
Received: from mga03.intel.com ([143.182.124.21]:29458 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755878Ab2K0EoY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 23:44:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,325,1352102400"; 
   d="scan'208";a="222774241"
From: "Brown, Len" <len.brown@intel.com>
To: Ethan Zhao <ethan.kernel@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        "Moore, Robert" <robert.moore@intel.com>,
        "Zheng, Lv" <lv.zheng@intel.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>
Subject: RE: [patch] Add IVB model 3e support to /drivers/idle/intel_idle.c
Thread-Topic: [patch] Add IVB model 3e support to /drivers/idle/intel_idle.c
Thread-Index: AQHNzFlXO/0IgnXTu0ikRjJ0Lrr5o5f9GtLA
Date: Tue, 27 Nov 2012 04:44:22 +0000
Message-ID: <1A7043D5F58CCB44A599DFD55ED4C94828D4CF4B@FMSMSX108.amr.corp.intel.com>
References: <CABawtvMQ1ShCWFcz3ot4OjT3APCZraG=f9PL2qzsXRM-6fGBmA@mail.gmail.com>
In-Reply-To: <CABawtvMQ1ShCWFcz3ot4OjT3APCZraG=f9PL2qzsXRM-6fGBmA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.200.108]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c index e872617..b0f6b4c 100644
> --- a/drivers/idle/intel_idle.c
> +++ b/drivers/idle/intel_idle.c
> @@ -413,6 +413,7 @@ static const struct x86_cpu_id intel_idle_ids[] = {
>         ICPU(0x2a, idle_cpu_snb),
>         ICPU(0x2d, idle_cpu_snb),
>         ICPU(0x3a, idle_cpu_ivb),
> +       ICPU(0x3e, idle_cpu_ivb),
>         {}

already in Linux-3.7

thanks,
-Len

