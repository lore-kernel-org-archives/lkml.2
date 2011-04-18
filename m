Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563Ab1DRQEd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 12:04:33 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48315 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755417Ab1DRQE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 12:04:27 -0400
Date: Mon, 18 Apr 2011 17:04:25 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com,
        a.zummo@towertech.it, johnpol@2ka.mipt.ru, cbou@mail.ru,
        dwmw2@infradead.org, lrg@slimlogic.co.uk
Subject: Re: [PATCH 13/14] regulator: check name in initialization of
 max8925
Message-ID: <20110418160424.GG1765@opensource.wolfsonmicro.com>
References: <1303135451-26362-14-git-send-email-haojian.zhuang@marvell.com>
 <20110418142855.GE2466@opensource.wolfsonmicro.com>
 <BANLkTim1QHe-hpyt0yQxKt2SBwtOAPQ3Bg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTim1QHe-hpyt0yQxKt2SBwtOAPQ3Bg@mail.gmail.com>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 11:33:34PM +0800, Haojian Zhuang wrote:

> So I want to avoid to use the index and check regulator[] one by one.
> I use a pointer to link
> all regulator data together. I just need to check whether the
> regulator pointer is valid or not.

Why?  I don't understand what the goal of this change is.
