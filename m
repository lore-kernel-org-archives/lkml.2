Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385Ab1DELuj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 07:50:39 -0400
Received: from www.hansjkoch.de ([178.63.77.200]:34083 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752743Ab1DELuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 07:50:37 -0400
Date: Tue, 5 Apr 2011 13:50:13 +0200
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Michal Simek <monstr@monstr.eu>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>, Wolfram Sang <w.sang@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org, john.williams@petalogix.com,
        linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: Re: [PATCH] uio/pdrv_genirq: Add OF support
Message-ID: <20110405115013.GA7028@local>
References: <20110331170321.GA2734@local>
 <4D94C09B.4070506@monstr.eu>
 <20110331192302.GD2734@local>
 <AANLkTin6iSVQtKo602hceod+4=cVUMG=GR7cCZvHg4nO@mail.gmail.com>
 <20110331203024.GE2734@local>
 <20110402103550.GA21760@pengutronix.de>
 <20110404170437.GA4830@local>
 <20110404173149.GB12200@pengutronix.de>
 <20110404182423.GC4830@local>
 <4D9AB5E8.3080401@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D9AB5E8.3080401@monstr.eu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 05, 2011 at 08:25:44AM +0200, Michal Simek wrote:
> Hans J. Koch wrote:
> >On Mon, Apr 04, 2011 at 07:31:49PM +0200, Wolfram Sang wrote:
> >>So, the solution for now is to simply add a default value and we can check
> >>later if it can be modified at runtime?
> >
> >Yes.
> 
> ok. Nice. What default value would you like to see as the version string?
> '0', 'generic', 'generic-uio', 'dt'

Actually, I don't care too much. '0' or 'generic' would be OK. I don't
like 'generic-uio' because it only applies to one driver, not UIO as
a whole.

> 
> Ok the last thing is how to handle compatible property.

if 'dt' means 'device tree' then I'd actually like that one since this
default is only used in the device tree case. Obviously you must not
change the version attributes set by platform devices.

Thanks,
Hans

