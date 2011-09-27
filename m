Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab1I0KWG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 06:22:06 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33266 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753345Ab1I0KWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 06:22:02 -0400
Date: Tue, 27 Sep 2011 11:22:00 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Harsha Priya <priya.harsha@intel.com>, Liam Girdwood <lrg@ti.com>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 2/2] ASoC: Staticise sst_platform_dai
Message-ID: <20110927102159.GD2910@opensource.wolfsonmicro.com>
References: <1317091087.315.1.camel@phoenix>
 <1317091130.315.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317091130.315.2.camel@phoenix>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 10:38:50AM +0800, Axel Lin wrote:
> It is not used outside this driver so no need to make the symbol global.
> 

Applied, thanks.
