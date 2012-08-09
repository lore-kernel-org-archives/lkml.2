Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759240Ab2HITEc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 15:04:32 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48837 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759206Ab2HITEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 15:04:30 -0400
Date: Thu, 9 Aug 2012 20:04:28 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: sameo@linux.intel.com, Laxman Dewangan <ldewangan@nvidia.com>,
        grant.likely@secretlab.ca, rob.herring@calxeda.com, swarren@nvidia.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH V3] regulator: tps6586x: add support for SYS rail
Message-ID: <20120809190428.GE24328@opensource.wolfsonmicro.com>
References: <1344152518-29378-1-git-send-email-ldewangan@nvidia.com>
 <5023EF22.8010206@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5023EF22.8010206@wwwdotorg.org>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2012 at 11:10:58AM -0600, Stephen Warren wrote:

> Sorry to bug people, but is everyone OK with this patch? I'm holding off
> checking in the Tegra-side device tree changes that add regulators until
> this patch is checked in (or at least approved) to make sure the Tegra
> .dts patches don't need any more changes.

I decided to go ahead and apply without Samuel's review since the MFD
changes are very small but in general four days is a bit of a fast
turnaround for most things...
