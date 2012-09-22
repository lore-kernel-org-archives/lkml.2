Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab2IVP4Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 11:56:25 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46081 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752860Ab2IVP4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 11:56:24 -0400
Date: Sat, 22 Sep 2012 11:56:20 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Liam Girdwood <lrg@ti.com>, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        AnilKumar Ch <anilkumar@ti.com>, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] regulator: deprecate regulator-compatible DT property
Message-ID: <20120922155620.GR4495@opensource.wolfsonmicro.com>
References: <1348178697-26314-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348178697-26314-1-git-send-email-swarren@wwwdotorg.org>
X-Cookie: Is this really happening?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 04:04:57PM -0600, Stephen Warren wrote:

> Mark, if this gets into 3.7, I can fix up all the Tegra .dts files during 3.8.

I don't know which branch you generated this against but it doesn't
apply to any of the obvious branches in my regulator tree.  There's a
modify/delete conflict in

   Documentation/devicetree/bindings/regulator/max8907.txt

which I don't seem to have.
