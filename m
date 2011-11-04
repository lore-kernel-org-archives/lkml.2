Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab1KDWX1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 18:23:27 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49370 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754814Ab1KDWX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 18:23:26 -0400
Date: Fri, 4 Nov 2011 22:23:23 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Olof Johansson <olof@lixom.net>
Cc: Rajendra Nayak <rnayak@ti.com>, grant.likely@secretlab.ca,
        patches@linaro.org, tony@atomide.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, lrg@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 2/4] regulator: adapt fixed regulator driver to dt
Message-ID: <20111104222323.GB16978@opensource.wolfsonmicro.com>
References: <1319702185-16108-1-git-send-email-rnayak@ti.com>
 <1319702185-16108-3-git-send-email-rnayak@ti.com>
 <20111104203422.GB3918@quad.lixom.net>
 <20111104210151.GA2541@opensource.wolfsonmicro.com>
 <20111104211824.GA5608@quad.lixom.net>
 <20111104212538.GA8266@opensource.wolfsonmicro.com>
 <CAOesGMh2_C+yx=_5PjqoKxZmAMvx-puRjq45s+G2kz2EaEEtqw@mail.gmail.com>
 <20111104215733.GD8266@opensource.wolfsonmicro.com>
 <CAOesGMh-fpUSMvOGkq_b4DVzFUby6pnMmKDXQ=sFJpn+g4FzOw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOesGMh-fpUSMvOGkq_b4DVzFUby6pnMmKDXQ=sFJpn+g4FzOw@mail.gmail.com>
X-Cookie: You will be misunderstood by everyone.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 04, 2011 at 03:09:32PM -0700, Olof Johansson wrote:

> But even things like allowing (optional) attributes such as
> startup-delay on non-fixed regulators could make sense. Keep in mind
> that the device tree should focus on describing the hardware, not just
> what the linux driver needs from it. So maybe instead of
> startup-delay, specifying ramp-up speed instead of time needed until
> power is good could be the way to go there.

This is in general something that a driver should know as a result of
knowing which regulator it's dealing with - in many cases these are
properties which can be varied at runtime on hardware which has register
control.  Replicating this into the device tree would make things more
error prone.
