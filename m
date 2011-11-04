Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635Ab1KDVSF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 17:18:05 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47027 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab1KDVSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 17:18:03 -0400
Date: Fri, 4 Nov 2011 14:18:24 -0700
From: Olof Johansson <olof@lixom.net>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Rajendra Nayak <rnayak@ti.com>, grant.likely@secretlab.ca,
        patches@linaro.org, tony@atomide.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, lrg@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 2/4] regulator: adapt fixed regulator driver to dt
Message-ID: <20111104211824.GA5608@quad.lixom.net>
References: <1319702185-16108-1-git-send-email-rnayak@ti.com>
 <1319702185-16108-3-git-send-email-rnayak@ti.com>
 <20111104203422.GB3918@quad.lixom.net>
 <20111104210151.GA2541@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111104210151.GA2541@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 04, 2011 at 09:01:52PM +0000, Mark Brown wrote:
> On Fri, Nov 04, 2011 at 01:34:22PM -0700, Olof Johansson wrote:
> 
> > Shouldn't a fixed regulator just be a subset of a fixed one? If so, should the
> > binding be merged with that one?
> 
> No, the fixed voltage regultor is a superset of a general regulator - it
> has additional information like the voltage it supplies and the optional
> enable GPIO.

Still, seems like it could be merged into one regulator binding.

> > > +- regulator-fixed-enabled-at-boot: 1 = yes, 0 = no
> 
> > Same here, you can drop the prefix. Also, the regular regulators use
> > "regulator-name" for the supply name, it would make sense to reuse the same
> > naming here, right?
> 
> I'm having a hard time associating your second comment with the property
> being discussed - could you clarify please?

It was the first comment I wrote on the whole block and later interspersed
other comments above, so I don't blame you for not understanding. The
second comment was related to the "regulator-fixed-supply" property at
the top of the block.


-Olof
