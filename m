Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096Ab1IPJOM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 05:14:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46120 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750951Ab1IPJOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 05:14:11 -0400
Date: Fri, 16 Sep 2011 10:14:09 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Wolfram Sang <w.sang@pengutronix.de>, Liam Girdwood <lrg@ti.com>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: tpa6130a2: Remove obsolete cleanup for clientdata
Message-ID: <20110916091409.GJ22062@opensource.wolfsonmicro.com>
References: <1315558020.2332.0.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315558020.2332.0.camel@phoenix>
X-Cookie: You have a truly strong individuality.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 09, 2011 at 04:47:00PM +0800, Axel Lin wrote:
> The i2c core will clear the clientdata pointer automatically,
> we don't have to set the `data' field to NULL in remove() or
> if probe() failed anymore.

Applied, thanks.
