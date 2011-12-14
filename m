Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233Ab1LNNr7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 08:47:59 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58915 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756289Ab1LNNr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 08:47:58 -0500
Date: Wed, 14 Dec 2011 21:47:53 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Ashish Jangam <ashish.jangam@kpitcummins.com>, linaro-dev@lists.linaro.org,
        dwmw2@infradead.org, linux-kernel@vger.kernel.org,
        Dajun <dajun.chen@diasemi.com>, paul.liu@linaro.org,
        sameo@linux.intel.com
Subject: Re: [PATCH 05/06] Power: DA9052 Battery module V6
Message-ID: <20111214134751.GA14317@opensource.wolfsonmicro.com>
References: <1323865676.32031.24.camel@dhruva>
 <20111214134209.GA21965@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111214134209.GA21965@oksana.dev.rtsoft.ru>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 05:42:09PM +0400, Anton Vorontsov wrote:

> I presume this depends on other patches, so I'm fine if this goes via
> non-battery tree,

There should be no direct dependencies for new MFDs - the Kconfig
required to depend on the MFD core means that the drivers can't be
selected until the core appears.
