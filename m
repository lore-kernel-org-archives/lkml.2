Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932829Ab0I0NAZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 09:00:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45509 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203Ab0I0NAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 09:00:24 -0400
Date: Mon, 27 Sep 2010 14:59:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
        torvalds@linux-foundation.org, Fenghua Yu <fenghua.yu@intel.com>,
        Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH v2] hwmon (coretemp): Fix build breakage if SMP is
 undefined
Message-ID: <20100927125946.GB2862@elte.hu>
References: <1285588796-20956-1-git-send-email-guenter.roeck@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285588796-20956-1-git-send-email-guenter.roeck@ericsson.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.5
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0334]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Guenter Roeck <guenter.roeck@ericsson.com> wrote:

> +#ifdef CONFIG_SMP
> +#endif
> +#ifdef CONFIG_SMP
> +#endif

Hm, this tickles my uglo-meter. Is there no cleaner way, preferably one 
that doesnt involve preprocessor directives?

Thanks,

	Ingo
