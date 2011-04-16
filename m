Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981Ab1DPSCu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 14:02:50 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57147 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750864Ab1DPSCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 14:02:43 -0400
Date: Sat, 16 Apr 2011 19:02:51 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: sameo@linux.intel.com, haojian.zhuang@gmail.com,
        linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH 13/13] regulator: max8925: enable i2c sequence for control
Message-ID: <20110416180251.GF25811@opensource.wolfsonmicro.com>
References: <1302706264-25815-5-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-6-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-7-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-8-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-9-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-10-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-11-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-12-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-13-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-14-git-send-email-haojian.zhuang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302706264-25815-14-git-send-email-haojian.zhuang@marvell.com>
X-Cookie: Chess tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 10:51:04PM +0800, Haojian Zhuang wrote:
> Force to enable i2c as power up/down sequence. Otherwise, SD/LDO can't
> be enabled or disabled via accessing i2c bus.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
