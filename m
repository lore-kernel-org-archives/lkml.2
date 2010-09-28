Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746Ab0I1LYY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 07:24:24 -0400
Received: from imr4.ericy.com ([198.24.6.8]:59602 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141Ab0I1LYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 07:24:23 -0400
Date: Tue, 28 Sep 2010 04:23:10 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        Pekka Enberg <penberg@kernel.org>, Fenghua Yu <fenghua.yu@intel.com>,
        Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH v3] hwmon (coretemp): Fix build breakage if SMP is
 undefined
Message-ID: <20100928112310.GA7033@ericsson.com>
References: <1285637552-1058-1-git-send-email-guenter.roeck@ericsson.com>
 <20100928082729.GA20898@elte.hu>
 <20100928101408.GA29525@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100928101408.GA29525@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 06:14:08AM -0400, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > v2: Fix compile warning due to unused variable i if SMP is undefined 
> > > v3: include asm/smp.h instead of using ifdef CONFIG_SMP
> > 
> > I've started testing this fix [...]
> 
> Works fine here.
> 
> Tested-by: Ingo Molnar <mingo@elte.hu>
> 
Great - thanks for your time!

Guenter
