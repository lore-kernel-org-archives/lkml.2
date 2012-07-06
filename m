Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632Ab2GFD5Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 23:57:25 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:12164 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422Ab2GFD5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 23:57:23 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 05 Jul 2012 20:57:18 -0700
Message-ID: <4FF66212.6080507@nvidia.com>
Date: Fri, 6 Jul 2012 09:27:06 +0530
From: Prashant Gaikwad <pgaikwad@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "mturquette@ti.com" <mturquette@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "ccross@android.com" <ccross@android.com>,
        "olof@lixom.net" <olof@lixom.net>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Subject: Re: [PATCH v3 0/6] Port Tegra to generic clk framework
References: <1341482120-3317-1-git-send-email-pgaikwad@nvidia.com> <4FF5E1C3.6070309@wwwdotorg.org>
In-Reply-To: <4FF5E1C3.6070309@wwwdotorg.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 July 2012 12:19 AM, Stephen Warren wrote:
> On 07/05/2012 03:55 AM, Prashant Gaikwad wrote:
>> This patch set ports Tegra clock code to generic clock framework.
> Unfortunately, this series causes some regressions, so I can't apply it
> now. Given that, it won't make 3.6 since I won't be around to apply it.

Ok.

> I tested both Tegra's for-next, and next-20120705, both plus this
> series, next-20120705 plus the fix for the common clock code
> __clk_set_parent() issue.
>
> The following all appeared to work OK:
>
> Cardhu DT
> Ventana DT
> Seaboard DT
> Springbank DT
> Harmony DT
> Harmony non-DT
>
> However, the following failed, all(?) in ways that prevented the system
> getting to the login prompt:
>
> Whistler DT
> AC100 DT
> AC100 non-DT
> Trimslice DT
> Trimslice non-DT
>
> (The one slight difference between the 2 branches I tested is that AC100
> and Trimslice booted using DT passed in next-20120705 but failed only in
> Tegra's for-next. Otherwise, all results were identical)
>
> I'll try to investigate what the issues are since I imagine you don't
> have access to these boards. But, I probably won't be able to fix this
> until I return from vacation.

I am not sure how DT/non-DT should make difference to this series.
I don't have access to those boards but if you can share the failure log 
I can try to pinpoint the fix.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-tegra" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

