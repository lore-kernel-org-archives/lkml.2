Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890Ab2DPPgx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 11:36:53 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10722 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754461Ab2DPPgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 11:36:51 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 16 Apr 2012 08:35:22 -0700
Date: Mon, 16 Apr 2012 18:34:56 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@ti.com>, Len Brown <len.brown@intel.com>,
        Trinabh Gupta <g.trinabh@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [RFC PATCH] cpuidle: allow per cpu latencies
Message-ID: <20120416153456.GB514@tbergstrom-lnx.Nvidia.com>
References: <1333619620-21201-1-git-send-email-pdeschrijver@nvidia.com>
 <4F7DA009.4010802@linux.intel.com>
 <CAMQu2gzwe0F3qcaTqASEPUASdG1SjpUxrBrSp-RrYLgy3W24OQ@mail.gmail.com>
 <4F7F0D52.8080305@linaro.org>
 <20120410102857.GA22721@tbergstrom-lnx.Nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120410102857.GA22721@tbergstrom-lnx.Nvidia.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Maybe we also want to make the 'disabled' flag per CPU then or provide some
> other way the number of C states can be different per CPU?

What do you think about this? Do we also want to make the disabled flag per
CPU? Or how should we deal with a different number of C states per CPU?

Thanks,

Peter.
