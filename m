Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013Ab0I1LZ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 07:25:59 -0400
Received: from imr3.ericy.com ([198.24.6.13]:49736 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751989Ab0I1LZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 07:25:58 -0400
Date: Tue, 28 Sep 2010 04:24:29 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        Pekka Enberg <penberg@kernel.org>, Fenghua Yu <fenghua.yu@intel.com>,
        Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH v3] hwmon (coretemp): Fix build breakage if SMP is
 undefined
Message-ID: <20100928112429.GB7033@ericsson.com>
References: <1285637552-1058-1-git-send-email-guenter.roeck@ericsson.com>
 <20100928082729.GA20898@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100928082729.GA20898@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 04:27:29AM -0400, Ingo Molnar wrote:
> 
> * Guenter Roeck <guenter.roeck@ericsson.com> wrote:
> 
> > Commit e40cc4bdfd4b89813f072f72bd9c7055814d3f0f introduced
> > a build breakage if CONFIG_SMP is undefined. This commit
> > fixes the problem.
> 
> This commit works around the problem in a hacky but not-so-ugly way.
> 
> ( You might also want to include Linus's suggestion about how to fix it 
>   for real in the future - so that we have at least some kind of record 
>   of it. )
> 
Done.

> > Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
> > Cc: Fenghua Yu <fenghua.yu@intel.com>
> 
> FYI, while i dont care about my Reported-by's but you lost a Reported-by 
> tag here - you should be as careful about them as about your own 
> signoffs.
> 
Added it back in.

Thanks,
Guenter
