Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932390Ab1EFNGe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 09:06:34 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54844 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932299Ab1EFNGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 09:06:32 -0400
Date: Fri, 6 May 2011 14:06:29 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: sameo@linux.intel.com, haojian.zhuang@gmail.com,
        linux-kernel@vger.kernel.org, lrg@slimlogic.co.uk,
        a.zummo@towertech.it, khali@linux-fr.org, ben-linux@fluff.org,
        Samuel Ortiz <samuel.ortiz@intel.com>
Subject: Re: [PATCH 4/6] mfd: 88pm860x: avoid to use constraint name in
 regulator driver
Message-ID: <20110506130629.GK23729@opensource.wolfsonmicro.com>
References: <2011050601>
 <1304673685-21324-1-git-send-email-haojian.zhuang@marvell.com>
 <1304673685-21324-2-git-send-email-haojian.zhuang@marvell.com>
 <1304673685-21324-3-git-send-email-haojian.zhuang@marvell.com>
 <1304673685-21324-4-git-send-email-haojian.zhuang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304673685-21324-4-git-send-email-haojian.zhuang@marvell.com>
X-Cookie: You will never know hunger.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 06, 2011 at 05:21:23PM +0800, Haojian Zhuang wrote:

> Avoid to use constraint name in regulator driver. So use regulator id is used
> instead in platform driver.

Looks like there's several machines using this which will also need
updating.  Otherwise looks OK

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
