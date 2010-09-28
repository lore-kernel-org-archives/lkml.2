Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758792Ab0I1KOy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 06:14:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48255 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752830Ab0I1KOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 06:14:53 -0400
Date: Tue, 28 Sep 2010 12:14:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org, Pekka Enberg <penberg@kernel.org>,
        Fenghua Yu <fenghua.yu@intel.com>, Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH v3] hwmon (coretemp): Fix build breakage if SMP is
 undefined
Message-ID: <20100928101408.GA29525@elte.hu>
References: <1285637552-1058-1-git-send-email-guenter.roeck@ericsson.com>
 <20100928082729.GA20898@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100928082729.GA20898@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.5
	-1.0 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1023]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > v2: Fix compile warning due to unused variable i if SMP is undefined 
> > v3: include asm/smp.h instead of using ifdef CONFIG_SMP
> 
> I've started testing this fix [...]

Works fine here.

Tested-by: Ingo Molnar <mingo@elte.hu>

Thanks,

	Ingo
