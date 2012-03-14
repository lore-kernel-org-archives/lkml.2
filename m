Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030323Ab2CNCGA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 22:06:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:48279 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965184Ab2CNCF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 22:05:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="120766564"
Message-ID: <4F5FFCC1.2030702@linux.intel.com>
Date: Tue, 13 Mar 2012 19:04:49 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Kevin Hilman <khilman@ti.com>
CC: Colin Cross <ccross@android.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@lists.linux-foundation.org, Len Brown <len.brown@intel.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Trinabh Gupta <g.trinabh@gmail.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        linux-omap@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 0/3] coupled cpuidle state support
References: <1324426147-16735-1-git-send-email-ccross@android.com> <4F1929E9.7070707@linaro.org> <8762e8kqi6.fsf@ti.com>
In-Reply-To: <8762e8kqi6.fsf@ti.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/13/2012 4:52 PM, Kevin Hilman wrote:
> Checking the ready_count seemed like an easy way to do this, but did you
> have any other mechanisms in mind for CPUs to communicate that they've
> exited/aborted?

this indeed is the tricky part (which I warned about earlier);
I've spent quite a lot of time (weeks) to get this provably working for
an Intel system with similar requirements... and it's extremely unfunny,
and needed firmware support to close some of the race conditions.

I sure hope that hardware with these requirements is on the way out...
it's not very OS friendly.

