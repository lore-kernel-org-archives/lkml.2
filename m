Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751356Ab1IDPyW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 11:54:22 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33246 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751026Ab1IDPyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 11:54:19 -0400
Date: Sun, 4 Sep 2011 08:54:15 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Harsha Priya <priya.harsha@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, Liam Girdwood <lrg@ti.com>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: sn95031: Fix the logic to find free channel
Message-ID: <20110904155414.GB21528@opensource.wolfsonmicro.com>
References: <1315028507.2268.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315028507.2268.1.camel@phoenix>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 03, 2011 at 01:41:47PM +0800, Axel Lin wrote:
> In the case of no free channel available,
> current implementation returns 0 instead of negative errno.
> 
> This patch fixes the logic to return -EINVAL if no free channel available.

Applied, thanks.
