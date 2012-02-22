Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818Ab2BVK6O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 05:58:14 -0500
Received: from ns.pmeerw.net ([87.118.82.44]:39412 "EHLO pmeerw.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754608Ab2BVK6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 05:58:12 -0500
Date: Wed, 22 Feb 2012 11:58:07 +0100 (CET)
From: Peter Meerwald <pmeerw@pmeerw.net>
To: Amit Daniel Kachhap <amit.kachhap@linaro.org>
cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        mjg59@srcf.ucam.org, linux-acpi@vger.kernel.org, lenb@kernel.org,
        linaro-dev@lists.linaro.org, durgadoss.r@intel.com, rob.lee@linaro.org,
        patches@linaro.org
Subject: Re: [PATCH 2/4] thermal: Add generic cpufreq cooling
 implementation
In-Reply-To: <1329905650-30161-3-git-send-email-amit.kachhap@linaro.org>
Message-ID: <alpine.DEB.2.01.1202221150070.32127@pmeerw.net>
References: <1329905650-30161-1-git-send-email-amit.kachhap@linaro.org> <1329905650-30161-3-git-send-email-amit.kachhap@linaro.org>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, only textual nitpicking below...

> user and the binding of these cooling devices to the corresponding
> trip points can be easily done as the registration API's return the
> cooling device pointer. The user of these api's are responsible for

API vs. api
use plural s: APIs

> +    This interface function registers the cpufreq cooling device with the name
> +    "thermal-cpufreq-%x". This api can support multiple instance of cpufreq cooling
> +    devices.
instances

> +	.freq_clip_pctg: Percentage of frequency to be clipped for each allowed
> +	 cpus.
cpu

> +    tab_size: the total number of cooling state.
states

p.

-- 

Peter Meerwald
+43-664-2444418 (mobile)
