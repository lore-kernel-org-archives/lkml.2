Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161Ab1KDV3O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 17:29:14 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52263 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751016Ab1KDV3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 17:29:13 -0400
Date: Fri, 4 Nov 2011 21:29:10 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Olof Johansson <olof@lixom.net>
Cc: Rajendra Nayak <rnayak@ti.com>, grant.likely@secretlab.ca,
        patches@linaro.org, tony@atomide.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, lrg@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 1/4] regulator: helper routine to extract
 regulator_init_data
Message-ID: <20111104212910.GB8266@opensource.wolfsonmicro.com>
References: <1319721864-30067-1-git-send-email-rnayak@ti.com>
 <20111104202905.GA3918@quad.lixom.net>
 <20111104211447.GC2541@opensource.wolfsonmicro.com>
 <20111104212216.GA5756@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111104212216.GA5756@quad.lixom.net>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 04, 2011 at 02:22:16PM -0700, Olof Johansson wrote:
> On Fri, Nov 04, 2011 at 09:14:48PM +0000, Mark Brown wrote:

> > The name will be fixed by the individual device bindings, this is
> > specifying the general form of a supply property.  Each device binding
> > will define the set of supplies that the device can use.

> Ah, ok. It shouldn't be a part of this binding then and instead be added
> to the bindings for the consumers.

I think it's useful to define how consumers are supposed to do this
somewhere - it is actually part of the core binding how consumers are
supposed to do this.

There's also a bit of magic here for chained supplies with one regulator
supplying another (eg, using a DCDC to drop the system supply down to a
lower voltage to supply a bunch of LDOs for improved efficiency).
