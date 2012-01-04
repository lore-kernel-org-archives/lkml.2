Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602Ab2ADR1y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 12:27:54 -0500
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:34926 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752585Ab2ADR1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 12:27:51 -0500
MIME-Version: 1.0
In-Reply-To: <87sjjw70zs.fsf@ti.com>
References: <1324426147-16735-1-git-send-email-ccross@android.com> <87sjjw70zs.fsf@ti.com>
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Date: Wed, 4 Jan 2012 18:27:29 +0100
Message-ID: <CAMQu2gwsw+RC+Y9P8r9Yjy+ADuQ-tPzcXPPncLxMjjb3tvdbbQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] coupled cpuidle state support
To: Kevin Hilman <khilman@ti.com>
Cc: Colin Cross <ccross@android.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-pm@lists.linux-foundation.org, Len Brown <len.brown@intel.com>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Trinabh Gupta <g.trinabh@gmail.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        linux-omap@vger.kernel.org, linux-tegra@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 4, 2012 at 1:41 AM, Kevin Hilman <khilman@ti.com> wrote:
> Colin Cross <ccross@android.com> writes:
>
>
>> This patch series implements an alternative solution, where each
>> cpu will wait in the WFI state until all cpus are ready to enter
>> a coupled state, at which point the coupled state function will
>> be called on all cpus at approximately the same time.
>
> This looks great, and is certainly preferred to hotplug IMO.
>
> [...]
>
>> None of the platforms I work with have an SMP idle implementation
>> upstream, so I can't easily show a patch that converts a platform
>> from hotplug governor to coupled cpuidle states.
>
> Basic OMAP4 CPUidle support is in now queued for v3.3 (see omap4
> branch Tony's tree[1].)
>
> Can you (or Santosh) send a patch that adds coupled support to that
> driver so it can see some broader testing on OMAP4?
>
I briefly attempted OMAP4 idle with this series but had some lock
up related issues which we faced in the older development.

Then I got busy into other activities which will keep me occupied for
next few weeks. I will be happy to share the patches in case some one
would like to have a look till then.

Regards
Santosh
