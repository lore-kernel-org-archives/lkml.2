Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779Ab1DRO1Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 10:27:16 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60474 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753510Ab1DRO1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 10:27:11 -0400
Date: Mon, 18 Apr 2011 15:27:08 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: sameo@linux.intel.com, haojian.zhuang@gmail.com,
        linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com,
        a.zummo@towertech.it, johnpol@2ka.mipt.ru, cbou@mail.ru,
        dwmw2@infradead.org, lrg@slimlogic.co.uk
Subject: Re: [PATCH 12/14] regulator: max8925: enable i2c sequence for
 control
Message-ID: <20110418142708.GD2466@opensource.wolfsonmicro.com>
References: <2011041801>
 <1303135451-26362-13-git-send-email-haojian.zhuang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303135451-26362-13-git-send-email-haojian.zhuang@marvell.com>
X-Cookie: Slow day.  Practice crawling.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 10:04:09PM +0800, Haojian Zhuang wrote:
> Force to enable i2c as power up/down sequence. Otherwise, SD/LDO can't
> be enabled or disabled via accessing i2c bus.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

but please work on the quality of your changelogs.
