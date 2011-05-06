Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751Ab1EFLtQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 07:49:16 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33588 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751336Ab1EFLtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 07:49:15 -0400
Date: Fri, 6 May 2011 12:49:12 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: sameo@linux.intel.com, haojian.zhuang@gmail.com,
        linux-kernel@vger.kernel.org, lrg@slimlogic.co.uk,
        a.zummo@towertech.it, khali@linux-fr.org, ben-linux@fluff.org
Subject: Re: [PATCH 6/6] mfd: max8925: remove checking on regulator[0]
Message-ID: <20110506114912.GH23729@opensource.wolfsonmicro.com>
References: <2011050601>
 <1304673685-21324-1-git-send-email-haojian.zhuang@marvell.com>
 <1304673685-21324-2-git-send-email-haojian.zhuang@marvell.com>
 <1304673685-21324-3-git-send-email-haojian.zhuang@marvell.com>
 <1304673685-21324-4-git-send-email-haojian.zhuang@marvell.com>
 <1304673685-21324-5-git-send-email-haojian.zhuang@marvell.com>
 <1304673685-21324-6-git-send-email-haojian.zhuang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304673685-21324-6-git-send-email-haojian.zhuang@marvell.com>
X-Cookie: You will never know hunger.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 06, 2011 at 05:21:25PM +0800, Haojian Zhuang wrote:
> Since regulator[0] is always checking in mfd driver, it results in
> registration failure without regulator[0].
> 
> Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
> Cc: Samuel Ortiz <sameo@linux.intel.com>

Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
