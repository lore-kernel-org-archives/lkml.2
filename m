Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994Ab0JHI0v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 04:26:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60044 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755585Ab0JHI0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 04:26:49 -0400
Date: Fri, 8 Oct 2010 10:26:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Fenghua Yu <fenghua.yu@intel.com>
Cc: H Peter Anvin <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Jean Delvare <khali@linux-fr.org>,
        Jin Dongming <jin.dongming@np.css.fujitsu.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH v2] x86/therm_throt.c: Fix error handling in
 thermal_throttle_add_dev
Message-ID: <20101008082631.GE13754@elte.hu>
References: <1283905550-18571-1-git-send-email-fenghua.yu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283905550-18571-1-git-send-email-fenghua.yu@intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Fenghua Yu <fenghua.yu@intel.com> wrote:

>  #ifdef CONFIG_HOTPLUG_CPU
>  	mutex_unlock(&therm_cpu_lock);
>  #endif

> +#ifdef CONFIG_HOTPLUG_CPU
> +	mutex_unlock(&therm_cpu_lock);
> +#endif

That's all very ugly.

Thanks,

	Ingo
