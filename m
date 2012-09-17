Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083Ab2IQKTT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 06:19:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59909 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751370Ab2IQKTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 06:19:18 -0400
Date: Mon, 17 Sep 2012 06:19:14 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: sameo@linux.intel.com, lrg@ti.com, rpurdie@rpsys.net,
        dmitry.torokhov@gmail.com, linux-kernel@vger.kernel.org,
        "Jett.Zhou" <jtzhou@marvell.com>
Subject: Re: [PATCH 3/9] regulator: 88pm860x: add pre-regulator support for
 88pm860x regulator
Message-ID: <20120917101914.GA5401@opensource.wolfsonmicro.com>
References: <1347855552-26213-1-git-send-email-haojian.zhuang@gmail.com>
 <1347855552-26213-4-git-send-email-haojian.zhuang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347855552-26213-4-git-send-email-haojian.zhuang@gmail.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 12:19:06PM +0800, Haojian Zhuang wrote:
> From: "Jett.Zhou" <jtzhou@marvell.com>
> 
> Pre-regulator of 88pm8606 is mainly for support charging based on vbus,
> it needs to be enabled for charging battery, and will be disabled in
> some exception condition like over-temp.
> Add the pre-regulator support for 88pm860x regulator driver.
> 
> Signed-off-by: Jett.Zhou <jtzhou@marvell.com>
> Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>

If you can sign this patch off I can apply it.
