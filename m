Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977Ab2DENhr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 09:37:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:63201 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752773Ab2DENhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 09:37:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="129029832"
Message-ID: <4F7DA009.4010802@linux.intel.com>
Date: Thu, 05 Apr 2012 06:37:13 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>, Len Brown <len.brown@intel.com>,
        Kevin Hilman <khilman@ti.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Trinabh Gupta <g.trinabh@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] cpuidle: allow per cpu latencies
References: <1333619620-21201-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1333619620-21201-1-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/5/2012 2:53 AM, Peter De Schrijver wrote:
> This patch doesn't update all cpuidle device registrations. I will do that

question is if you want to do per cpu latencies, or if you want to have
both types of C state in one big table, and have each of the tegra cpyu
types pick half of them...

