Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab2DIG7a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 02:59:30 -0400
Received: from na3sys009aog137.obsmtp.com ([74.125.149.18]:52444 "EHLO
	psmtp.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752244Ab2DIG73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 02:59:29 -0400
Message-ID: <4F8288C8.50507@ti.com>
Date: Mon, 09 Apr 2012 12:29:20 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Colin Cross <ccross@android.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@lists.linux-foundation.org, Kevin Hilman <khilman@ti.com>,
        Len Brown <len.brown@intel.com>, Trinabh Gupta <g.trinabh@gmail.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: Re: [PATCHv2 5/5] cpuidle: coupled: add trace events
References: <1331749794-8056-1-git-send-email-ccross@android.com> <1331749794-8056-6-git-send-email-ccross@android.com>
In-Reply-To: <1331749794-8056-6-git-send-email-ccross@android.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 March 2012 11:59 PM, Colin Cross wrote:
> Adds trace events to allow debugging of coupled cpuidle.
> Can be used to verify cpuidle performance, including time spent
> spinning and time spent in safe states.  Not intended for merging.
> 
> Signed-off-by: Colin Cross <ccross@android.com>
> ---
I found the trace events quite useful for debug and also to monitor
the cpuidle performance.

I guess we should add these trace events to the core code unless
and until there is a strong reason not to do so.

Regards
Santosh
