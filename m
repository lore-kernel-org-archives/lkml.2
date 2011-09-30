Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796Ab1I3M4u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 08:56:50 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48525 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752029Ab1I3M4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 08:56:49 -0400
Date: Fri, 30 Sep 2011 13:56:48 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Vladimir Barinov <vova.barinov@gmail.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: tlv320aic3x: Use driver_data field of struct
 i2c_device_id to identify models
Message-ID: <20110930125647.GL5366@opensource.wolfsonmicro.com>
References: <1317218208.8008.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317218208.8008.1.camel@phoenix>
X-Cookie: Blow it out your ear.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 28, 2011 at 09:56:48PM +0800, Axel Lin wrote:
> Save model information in driver_data so we can simplify the implementation.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied, thanks.
