Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934928Ab1JEQQY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 12:16:24 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55649 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934476Ab1JEQQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 12:16:23 -0400
Date: Wed, 5 Oct 2011 17:16:21 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: ak4535: Set codec->hw_write to i2c_master_send
Message-ID: <20111005161620.GB11528@opensource.wolfsonmicro.com>
References: <1317799677.21481.6.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317799677.21481.6.camel@phoenix>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 05, 2011 at 03:27:56PM +0800, Axel Lin wrote:
> It was removed in commit f0fba2ad
> "ASoC: multi-component - ASoC Multi-Component Support".
> 
> Add it back, otherwise codec->hw_write points to NULL.

It's better to fix the driver not to use hw_write any more, it's broken
without anyway.
