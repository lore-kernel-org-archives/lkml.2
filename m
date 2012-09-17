Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500Ab2IQKAG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 06:00:06 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42926 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755482Ab2IQKAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 06:00:01 -0400
Date: Mon, 17 Sep 2012 05:59:57 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: sameo@linux.intel.com, lrg@ti.com, rpurdie@rpsys.net,
        dmitry.torokhov@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/9] mfd: 88pm860x: support dt
Message-ID: <20120917095956.GC4829@opensource.wolfsonmicro.com>
References: <1347855552-26213-1-git-send-email-haojian.zhuang@gmail.com>
 <1347855552-26213-8-git-send-email-haojian.zhuang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347855552-26213-8-git-send-email-haojian.zhuang@gmail.com>
X-Cookie: Beware of low-flying butterflies.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 12:19:10PM +0800, Haojian Zhuang wrote:
> Signed-off-by: Haojian Zhuang <haojian.zhuang@gmail.com>
> ---
>  drivers/input/touchscreen/88pm860x-ts.c |   46 +++++++++++++++--------
>  drivers/leds/leds-88pm860x.c            |   33 +++++++++++++++-
>  drivers/mfd/88pm860x-core.c             |   62 ++++++++++++++++++++++++++-----
>  drivers/regulator/88pm8607.c            |   35 ++++++++++++++++-
>  drivers/rtc/rtc-88pm860x.c              |   43 ++++++++++++++++-----
>  drivers/video/backlight/88pm860x_bl.c   |   39 +++++++++++++++++--
>  include/linux/mfd/88pm860x.h            |    4 +-
>  7 files changed, 221 insertions(+), 41 deletions(-)

Any new DT bindings should come with documentation in the appropriate
places under Documentation/devicetree.
