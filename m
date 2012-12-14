Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932140Ab2LNRoJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 12:44:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34882 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756101Ab2LNRoG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 12:44:06 -0500
Message-ID: <50CB6554.8060305@redhat.com>
Date: Fri, 14 Dec 2012 12:43:48 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Sivaram Nair <sivaramn@nvidia.com>
CC: rafael.j.wysocki@intel.com, len.brown@intel.com, daniel.lezcano@linaro.org,
        khilman@ti.com, ccross@android.com, youquan.song@intel.com,
        akpm@linux-foundation.org, shuox.liu@intel.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] cpuidle: fix finding state with min power_usage
References: <1355491060-970-1-git-send-email-sivaramn@nvidia.com>
In-Reply-To: <1355491060-970-1-git-send-email-sivaramn@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2012 08:17 AM, Sivaram Nair wrote:
> Since cpuidle_state.power_usage is a signed value, use INT_MAX (instead
> of -1) to init the local copies so that functions that tries to find
> cpuidle states with minimum power usage works correctly even if they use
> non-negative values.
>
> Signed-off-by: Sivaram Nair <sivaramn@nvidia.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
