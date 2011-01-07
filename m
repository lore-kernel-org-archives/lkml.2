Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab1AGJ7o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 04:59:44 -0500
Received: from mail4.comsite.net ([205.238.176.238]:45110 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495Ab1AGJ7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 04:59:42 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.127.106;
From: Milton Miller <miltonm@bga.com>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        <qi.wang@intel.com>, <yong.y.wang@intel.com>, <joel.clark@intel.com>,
        <kok.howg.ewe@intel.com>
Subject: Re: [PATCH 1/3] spi_topcliff_pch: support new device ML7213
Message-Id: <topcliff-split-resend2@mdm.bga.com>
In-Reply-To: <46862922F48B45F781832619CF3F4B79@hacdom.okisemi.com>
References: <1293449027-3219-1-git-send-email-tomoya-linux@dsn.okisemi.com>
	<20101229064937.GC8172@angua.secretlab.ca>
	<280596192AA74D208C2C5F6389DBE8C1@hacdom.okisemi.com>
	<20110105163835.GD17272@angua.secretlab.ca>
	<46862922F48B45F781832619CF3F4B79@hacdom.okisemi.com>
Date: Fri, 07 Jan 2011 03:57:58 -0600
X-Originating-IP: 71.22.127.106
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On: Mon, 27 Dec 2010 at about 11:23:45 -0000, Tomoya MORINAGA wrote:
> On Thursday, January 06, 2011 1:39 AM, Grant Likely wrote:
> > As far as examples go, drivers/mfd/timberdale.c seems reasonable, if a 
> > bit larger than what you need.
> 
> Thank you for your suggestion.
> However, though seeing this driver, I didn't understand your intention.
> It seems platform_device/platform_driver are not used in this.
> Which part of this driver do you want to show me as reference ?

follow mfd_add_devices into drivers/mfd/mfd-core.c

milton
