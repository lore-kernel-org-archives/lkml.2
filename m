Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab2FUKnp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 06:43:45 -0400
Received: from mga11.intel.com ([192.55.52.93]:29630 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753414Ab2FUKno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 06:43:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="168453176"
Date: Thu, 21 Jun 2012 18:43:40 +0800
From: Fengguang Wu <wfg@linux.intel.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        "'Liam Girdwood'" <lrg@ti.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "'Kim, Milo'" <Milo.Kim@ti.com>,
        "'Axel Lin'" <axel.lin@gmail.com>
Subject: Re: akpm 117/143] ERROR: "devm_gpio_request_one"
 [drivers/video/backlight/l4f00242t03.ko] undefined!
Message-ID: <20120621104340.GA12679@localhost>
References: <20120621101721.GA12365@localhost>
 <000e01cd4f98$d1366a40$73a33ec0$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000e01cd4f98$d1366a40$73a33ec0$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > ERROR: "devm_gpio_request_one" [drivers/video/backlight/l4f00242t03.ko] undefined!
> 
> Hi Fengguang,
> 
> The patch a291ede7be8359a8986740b11b93f9c80e40210b ' backlight-l4f00242t03-use-devm_gpio_request_one-fix'
> is necessary to fix the export problem.
> 
> In my opinion, Andrew Morton will fold these patches as usual.

Err.. Sorry for the noise! This is a bit awkward situation. It seems
that I'll need to teach my scripts to detect the follow-up commits
with title "XXX-fix" and double check such commits before sending out
error reports.

Thanks,
Fengguang
