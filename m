Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab1I0KVx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 06:21:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33257 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753129Ab1I0KVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 06:21:52 -0400
Date: Tue, 27 Sep 2011 11:21:50 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Harsha Priya <priya.harsha@intel.com>, Liam Girdwood <lrg@ti.com>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 1/2] ASoC: Remove unused fields in struct mfld_mc_private
Message-ID: <20110927102150.GC2910@opensource.wolfsonmicro.com>
References: <1317091087.315.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317091087.315.1.camel@phoenix>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 10:38:07AM +0800, Axel Lin wrote:
> Both *socdev and *codec of struct mfld_mc_private are not being used
> in this driver, remove it.

Applied, thanks.
