Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744Ab1KWTBb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 14:01:31 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54134 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751935Ab1KWTBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 14:01:30 -0500
Date: Wed, 23 Nov 2011 19:01:14 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Rajendra Nayak <rnayak@ti.com>
Cc: grant.likely@secretlab.ca, robherring2@gmail.com,
        devicetree-discuss@lists.ozlabs.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tony@atomide.com, lrg@ti.com,
        b-cousson@ti.com, patches@linaro.org, linux-kernel@vger.kernel.org,
        shawn.guo@freescale.com, linaro-dev@lists.linaro.org, olof@lixom.net
Subject: Re: [PATCH v5 0/4] Device tree support for regulators
Message-ID: <20111123190114.GB17587@opensource.wolfsonmicro.com>
References: <1321615040-13257-1-git-send-email-rnayak@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321615040-13257-1-git-send-email-rnayak@ti.com>
X-Cookie: You will never know hunger.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 18, 2011 at 04:47:16PM +0530, Rajendra Nayak wrote:

> For the first 2 patches (1/4 and 2/4) I have dropped
> Acks from Mark, since they have changed to some extent
> from the last post and retained the Acks recieved on the
> last 2 patches (3/4 and 4/4) as they remain unchanged.

Looks good and nobody complained yet so I've dropped this into -next to
get it a bit of exposure.  I'm reasonably happy that the DT people have
already had a good chance to look at this stuff on previous iterations.
Unless there's any major changes or we need to back it out later on
for some other reason please send incremental patches.
