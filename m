Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759263Ab0I0NQJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 09:16:09 -0400
Received: from imr4.ericy.com ([198.24.6.8]:33208 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754896Ab0I0NQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 09:16:07 -0400
Date: Mon, 27 Sep 2010 06:15:10 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        Fenghua Yu <fenghua.yu@intel.com>, Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH v2] hwmon (coretemp): Fix build breakage if SMP is
 undefined
Message-ID: <20100927131510.GB2277@ericsson.com>
References: <1285588796-20956-1-git-send-email-guenter.roeck@ericsson.com>
 <20100927125946.GB2862@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100927125946.GB2862@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 08:59:46AM -0400, Ingo Molnar wrote:
> 
> * Guenter Roeck <guenter.roeck@ericsson.com> wrote:
> 
> > +#ifdef CONFIG_SMP
> > +#endif
> > +#ifdef CONFIG_SMP
> > +#endif
> 
> Hm, this tickles my uglo-meter. Is there no cleaner way, preferably one 
> that doesnt involve preprocessor directives?
> 
Mine too, but not at 6am in the morning (actually 5am when I wrote it),
and right now I thought it more important to fix the kernel breakage.

I'll think about it and see if I can find something better. But I would
still prefer to have this one applied and submit a cleaner solution later on
(if I find one). Preferrably, as you suggested, without any CONFIG_SMP
declarations.

Fwiw, there are several similar "#ifdef CONFIG_SMP" in this driver already,
so it would definitely be good to find a cleaner solution.

Thanks,
Guenter
