Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294Ab1DDSYg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 14:24:36 -0400
Received: from www.hansjkoch.de ([178.63.77.200]:50229 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752864Ab1DDSYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 14:24:35 -0400
Date: Mon, 4 Apr 2011 20:24:24 +0200
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Michal Simek <monstr@monstr.eu>, devicetree-discuss@lists.ozlabs.org,
        john.williams@petalogix.com, linux-kernel@vger.kernel.org,
        gregkh@suse.de
Subject: Re: [PATCH] uio/pdrv_genirq: Add OF support
Message-ID: <20110404182423.GC4830@local>
References: <20110331124925.GA2202@pengutronix.de>
 <4D948189.9070606@monstr.eu>
 <20110331170321.GA2734@local>
 <4D94C09B.4070506@monstr.eu>
 <20110331192302.GD2734@local>
 <AANLkTin6iSVQtKo602hceod+4=cVUMG=GR7cCZvHg4nO@mail.gmail.com>
 <20110331203024.GE2734@local>
 <20110402103550.GA21760@pengutronix.de>
 <20110404170437.GA4830@local>
 <20110404173149.GB12200@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110404173149.GB12200@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 04, 2011 at 07:31:49PM +0200, Wolfram Sang wrote:
> 
> So, the solution for now is to simply add a default value and we can check
> later if it can be modified at runtime?

Yes.

Thanks,
Hans
