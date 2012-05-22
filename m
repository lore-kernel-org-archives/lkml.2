Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889Ab2EVVrm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 17:47:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:40810 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752348Ab2EVVrl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 17:47:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="155844952"
Date: Tue, 22 May 2012 23:57:43 +0200
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
Message-ID: <20120522215743.GF10210@sortiz-mobl>
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

Hi Jongwha,

On Mon, May 21, 2012 at 06:51:45PM +0900, Jonghwa Lee wrote:
> This patch is device driver for MAX77686 chip.
> MAX77686 is PMIC and includes regulator and rtc on it.
> This driver is core of MAX77686 chip, so provides common support for accessing
> on-chip devices. It uses irq_domain to manage irq and regmap to read/write data
> to its register with i2c bus.
I'll try to push this one after rc1, or as a late merge window pull request.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
