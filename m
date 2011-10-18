Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932896Ab1JRQAu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 12:00:50 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59241 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755739Ab1JRQAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 12:00:49 -0400
Date: Tue, 18 Oct 2011 17:00:46 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Shawn Guo <shawn.guo@freescale.com>
Cc: Rajendra Nayak <rnayak@ti.com>, grant.likely@secretlab.ca,
        patches@linaro.org, tony@atomide.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, lrg@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 3/5] regulator: helper routine to extract
 regulator_init_data
Message-ID: <20111018160046.GD28501@opensource.wolfsonmicro.com>
References: <1318263578-7407-1-git-send-email-rnayak@ti.com>
 <1318263578-7407-4-git-send-email-rnayak@ti.com>
 <20111016145536.GA29885@S2100-06.ap.freescale.net>
 <4E9BAC4D.3010402@ti.com>
 <20111018115836.GC30703@S2100-06.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111018115836.GC30703@S2100-06.ap.freescale.net>
X-Cookie: Avoid gunfire in the bathroom tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 07:58:37PM +0800, Shawn Guo wrote:

> I understand that ideally device tree is supposed to describe pure
> hardware configurations.  But practically, when migrating a driver
> to device tree probe, we are trying to move the configurations
> described by platform_data into device tree to save the use of
> platform_data for device tree probe.  Then some of the configuration
> may not be so purely hardware related.  But I do not see this is a
> critical problem.

It's not just Linux-specific stuff, some of this is even specific to
what current Linux drivers can do - updating the kernel could mean a
different set of constraints.
