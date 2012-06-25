Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284Ab2FYI0J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 04:26:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:4386 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539Ab2FYI0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 04:26:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="162180722"
Date: Mon, 25 Jun 2012 10:37:04 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Jonghwa Lee <jonghwa3.lee@samsung.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Gridwodd <lrg@ti.com>, Alessandro Zummo <a.zummo@towertech.it>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Chiwoong Byun <woong.byun@samsung.com>
Subject: Re: [PATCH v4 1/3] mfd: MAX77686: Add Maxim 77686 mfd driver
Message-ID: <20120625083704.GA18600@sortiz-mobl>
References: <1337593907-6615-1-git-send-email-jonghwa3.lee@samsung.com>
 <1337593907-6615-2-git-send-email-jonghwa3.lee@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337593907-6615-2-git-send-email-jonghwa3.lee@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonghwa,

On Mon, May 21, 2012 at 06:51:45PM +0900, Jonghwa Lee wrote:
> This patch is device driver for MAX77686 chip.
> MAX77686 is PMIC and includes regulator and rtc on it.
> This driver is core of MAX77686 chip, so provides common support for accessing
> on-chip devices. It uses irq_domain to manage irq and regmap to read/write data
> to its register with i2c bus.
> 
Patch applied to my for-next branch, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
