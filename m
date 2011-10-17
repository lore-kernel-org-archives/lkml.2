Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152Ab1JQERa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 00:17:30 -0400
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:56488 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751165Ab1JQER2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 00:17:28 -0400
Message-ID: <4E9BAC4D.3010402@ti.com>
Date: Mon, 17 Oct 2011 09:47:17 +0530
From: Rajendra Nayak <rnayak@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.20) Gecko/20110805 Thunderbird/3.1.12
MIME-Version: 1.0
To: Shawn Guo <shawn.guo@freescale.com>
CC: broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca,
        patches@linaro.org, tony@atomide.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, lrg@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 3/5] regulator: helper routine to extract regulator_init_data
References: <1318263578-7407-1-git-send-email-rnayak@ti.com> <1318263578-7407-4-git-send-email-rnayak@ti.com> <20111016145536.GA29885@S2100-06.ap.freescale.net>
In-Reply-To: <20111016145536.GA29885@S2100-06.ap.freescale.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I do not see that of_get_regulation_constraints() covers the following
> fields.  We do not support them for DT probe?

I left these out as I wasn't sure how such (if at all) Linux specific 
params should be passed through dt, and I am still not quite sure :(

>
> struct regulation_constraints {
>
>          char *name;
>
> 	...
>
>          /* regulator suspend states for global PMIC STANDBY/HIBERNATE */
>          struct regulator_state state_disk;
>          struct regulator_state state_mem;
>          struct regulator_state state_standby;
>          suspend_state_t initial_state; /* suspend state to set at init */
>
>          /* mode to set on startup */
>          unsigned int initial_mode;
>
>          /* constraint flags */
> 	...
>          unsigned apply_uV:1;    /* apply uV constraint if min == max */
> };
>

