Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759086Ab0I0X3t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 19:29:49 -0400
Received: from imr4.ericy.com ([198.24.6.8]:55344 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756459Ab0I0X3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 19:29:48 -0400
Date: Mon, 27 Sep 2010 16:27:16 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Pekka Enberg <penberg@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        Fenghua Yu <fenghua.yu@intel.com>, Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH v2] hwmon (coretemp): Fix build breakage if SMP is
 undefined
Message-ID: <20100927232716.GB4744@ericsson.com>
References: <1285588796-20956-1-git-send-email-guenter.roeck@ericsson.com>
 <20100927125946.GB2862@elte.hu>
 <AANLkTinPHP8WhoAZQqcmhotEfFa6=mG_Acy+xCBQ0_5+@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <AANLkTinPHP8WhoAZQqcmhotEfFa6=mG_Acy+xCBQ0_5+@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 09:02:57AM -0400, Pekka Enberg wrote:
> On Mon, Sep 27, 2010 at 3:59 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Guenter Roeck <guenter.roeck@ericsson.com> wrote:
> >
> >> +#ifdef CONFIG_SMP
> >> +#endif
> >> +#ifdef CONFIG_SMP
> >> +#endif
> >
> > Hm, this tickles my uglo-meter. Is there no cleaner way, preferably one
> > that doesnt involve preprocessor directives?
> 
> Implement cpu_sibling_mask() on UP so that the loop goes away?

So what is the take ? Looks like Linus won't accept my patch without someone 
else signing off on it. If the uglo-meter prevents it from being accepted,
I'll be happy to submit the SMP cleanup patch instead. As I mentioned
before, I would prefer that to go into -next.

Guenter
