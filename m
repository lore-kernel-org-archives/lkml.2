Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050Ab1L2Kfp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 05:35:45 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46679 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752839Ab1L2Kfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 05:35:40 -0500
Date: Thu, 29 Dec 2011 10:35:37 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] mfd: Fix section mismatch warning for da9052
Message-ID: <20111229103537.GD2909@opensource.wolfsonmicro.com>
References: <1325150268.13424.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325150268.13424.1.camel@phoenix>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 29, 2011 at 05:17:48PM +0800, Axel Lin wrote:
> This patch changes da9052_subdev_info to __devinitdata and marks __devinit
> for probe functions to fix below build warning.
> For completeness, also marks __devexit for remove functions.

That should be fixed already in -next.
