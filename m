Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094Ab1LEK5h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 05:57:37 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37764 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755825Ab1LEK5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 05:57:35 -0500
Date: Mon, 5 Dec 2011 10:57:33 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: Rajendra Nayak <rnayak@ti.com>, grant.likely@secretlab.ca,
        robherring2@gmail.com, linaro-dev@lists.linaro.org, patches@linaro.org,
        tony@atomide.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, olof@lixom.net,
        linux-omap@vger.kernel.org, lrg@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 1/4] regulator: helper routine to extract
 regulator_init_data
Message-ID: <20111205105733.GE11150@opensource.wolfsonmicro.com>
References: <1321615040-13257-1-git-send-email-rnayak@ti.com>
 <1321615040-13257-2-git-send-email-rnayak@ti.com>
 <CAJuYYwRO+AS=WmQfNAe8L6Gi5Dm4VsCuVqk3X5Nb8uUYAdLnJQ@mail.gmail.com>
 <20111204155433.GA16287@opensource.wolfsonmicro.com>
 <CAJuYYwQ-9wCu-+q0S2YYeFYemq74ULdZ-EwPGLWKHA4+0VZcsA@mail.gmail.com>
 <20111205103447.GC11150@opensource.wolfsonmicro.com>
 <CAJuYYwSRW-=XufvHS1miO2xNANwQMZqPbt=VyPEonywnAsvVUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJuYYwSRW-=XufvHS1miO2xNANwQMZqPbt=VyPEonywnAsvVUQ@mail.gmail.com>
X-Cookie: Is this really happening?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 05, 2011 at 04:14:40PM +0530, Thomas Abraham wrote:
> On 5 December 2011 16:04, Mark Brown

> > With the regulator device tree bindings if the regulator is configured
> > to run a single voltage the bindings will set apply_uV unconditionally
> > so there's no need for a separate constraint.

> Sorry if I have missed this, but I could not find 'apply_uV' being set
> as you described in the v5 of the regulator-dt patchset.

Yes, looks like Rajendra missed that - just fixed it.
