Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab1DSKvM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 06:51:12 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37174 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754464Ab1DSKvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 06:51:10 -0400
Date: Tue, 19 Apr 2011 11:51:03 +0100
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
Subject: Re: [PATCH 13/14] regulator: check name in initialization of
	max8925
Message-ID: <20110419105103.GF9462@sirena.org.uk>
References: <1303135451-26362-14-git-send-email-haojian.zhuang@marvell.com> <20110418142855.GE2466@opensource.wolfsonmicro.com> <BANLkTim1QHe-hpyt0yQxKt2SBwtOAPQ3Bg@mail.gmail.com> <20110418160424.GG1765@opensource.wolfsonmicro.com> <25B60CDC2F704E4E9D88FFD52780CB4C05CF05B424@SC-VEXCH1.marvell.com> <20110419080919.GC16357@opensource.wolfsonmicro.com> <25B60CDC2F704E4E9D88FFD52780CB4C05CF05B4CC@SC-VEXCH1.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25B60CDC2F704E4E9D88FFD52780CB4C05CF05B4CC@SC-VEXCH1.marvell.com>
X-Cookie: APL hackers do it in the quad.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 19, 2011 at 01:28:23AM -0700, Haojian Zhuang wrote:

> >> 	There's issue in max8925_core.c since we can't assume regulator[0]
> >always declared in machine driver.

> >What is the issue?  It's trivial to skip the regulator if the data is
> >null.

> It skiped all regulators if regulator[0] isn't decleared.
> 	(pdata == NULL) || (pdata->regulator[0] == NULL)

> So it's a bug.

Surely the obvious fix is to fix the issue and not skip all the
regulators if an individual regulator has no data?
