Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468Ab1DSIJM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 04:09:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48009 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751490Ab1DSIJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 04:09:10 -0400
Date: Tue, 19 Apr 2011 09:09:19 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Haojian Zhuang <hzhuang1@marvell.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "johnpol@2ka.mipt.ru" <johnpol@2ka.mipt.ru>,
        "cbou@mail.ru" <cbou@mail.ru>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>
Subject: Re: [PATCH 13/14] regulator: check name in initialization of max8925
Message-ID: <20110419080919.GC16357@opensource.wolfsonmicro.com>
References: <1303135451-26362-14-git-send-email-haojian.zhuang@marvell.com>
 <20110418142855.GE2466@opensource.wolfsonmicro.com>
 <BANLkTim1QHe-hpyt0yQxKt2SBwtOAPQ3Bg@mail.gmail.com>
 <20110418160424.GG1765@opensource.wolfsonmicro.com>
 <25B60CDC2F704E4E9D88FFD52780CB4C05CF05B424@SC-VEXCH1.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25B60CDC2F704E4E9D88FFD52780CB4C05CF05B424@SC-VEXCH1.marvell.com>
X-Cookie: Is this really happening?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 07:42:09PM -0700, Haojian Zhuang wrote:
> 	Machine driver:
> 		Platform data:
> 			.regulator[0]	= xxx
> 			.regulator[1]	= xxx

> 	The index of regulator array is id of buck and ldo.
> 	There's issue in max8925_core.c since we can't assume regulator[0] always declared in machine driver.

What is the issue?  It's trivial to skip the regulator if the data is
null.
