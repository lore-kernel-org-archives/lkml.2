Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757783Ab1GDRX6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 13:23:58 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42807 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755138Ab1GDRX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 13:23:57 -0400
Date: Mon, 4 Jul 2011 10:23:46 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jin Park <jinyoungp@nvidia.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Richard Purdie <rpurdie@rpsys.net>,
        Liam Girdwood <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] regulator: aat2870: Add AAT2870 regulator driver
Message-ID: <20110704172343.GE28726@opensource.wolfsonmicro.com>
References: <1309769022-11083-1-git-send-email-jinyoungp@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309769022-11083-1-git-send-email-jinyoungp@nvidia.com>
X-Cookie: You will have long and healthy life.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 04, 2011 at 05:43:42PM +0900, Jin Park wrote:

> Add regulator driver for AnalogicTech AAT2870.
> 
> Signed-off-by: Jin Park <jinyoungp@nvidia.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

When posting new revisions of patches all the stuff in SubmittingPatches
still applies, especially the bit about not including extraneous stuff
before the ---.  Doing this means it's much easier to apply your patches
with tools like git am.
