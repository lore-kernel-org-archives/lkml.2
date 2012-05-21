Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773Ab2EUGpA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 02:45:00 -0400
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:48791 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752441Ab2EUGo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 02:44:58 -0400
Message-ID: <4FB9E461.9060405@ti.com>
Date: Mon, 21 May 2012 12:14:49 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Colin Cross <ccross@android.com>
CC: Len Brown <len.brown@intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-pm@lists.linux-foundation.org, Kevin Hilman <khilman@ti.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 0/2] bug fixes for coupled cpuidle
References: <1337364324-12171-1-git-send-email-ccross@android.com>
In-Reply-To: <1337364324-12171-1-git-send-email-ccross@android.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 May 2012 11:35 PM, Colin Cross wrote:
> The last modifications made to the coupled cpuidle patches introduced
> two bugs that I missed during testing.  The online count was never
> initialized, causing coupled idle to always wait and never enter the
> ready loop.  That hid the second bug, the ready count could never be
> decremented after exiting idle.
> 
> Len, these two patches could be squashed into patch 3 of the original
> set.  If you do squash them, you could also add Rafael's tags to the
> set (Reviewed-by on 1 and 2, acked-by on 3).  Or I can reupload the
> whole stack as v5 if you prefer.

I confirm that these two fixes are needed to get couple idle
v4 series working.

Regards
Santosh

