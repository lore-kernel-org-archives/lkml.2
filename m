Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760017Ab2IFABr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 20:01:47 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40815 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759979Ab2IFABm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 20:01:42 -0400
Date: Thu, 6 Sep 2012 08:01:37 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Liam Girdwood <lrg@ti.com>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH V4] regulator: tps6586x: add support for SYS rail
Message-ID: <20120906000136.GM10580@opensource.wolfsonmicro.com>
References: <1346791419-31290-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346791419-31290-1-git-send-email-swarren@wwwdotorg.org>
X-Cookie: Bridge ahead.  Pay troll.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2012 at 02:43:39PM -0600, Stephen Warren wrote:
> From: Laxman Dewangan <ldewangan@nvidia.com>
> 
> Device have SYS rail which is always ON. It is system power bus. LDO5
> and LDO_RTC get powered through this rail internally. Add support for
> this rail and make the LDO5/LDO_RTC supply by it. Update document
> accordingly.

Applied, thanks.  It'll be next week before I can give you a signed tag
to pull, sorry.
