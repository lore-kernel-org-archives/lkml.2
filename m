Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182Ab2IMHKo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 03:10:44 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55896 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756131Ab2IMHKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 03:10:41 -0400
Date: Thu, 13 Sep 2012 09:09:48 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the
 i2c-embedded tree
Message-ID: <20120913070948.GC19497@pengutronix.de>
References: <20120913164120.cde08ac1517e641386b147d8@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120913164120.cde08ac1517e641386b147d8@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Thu, Sep 13, 2012 at 04:41:20PM +1000, Stephen Rothwell wrote:
> Today's linux-next merge of the arm-soc tree got a conflict in
> drivers/i2c/busses/i2c-omap.c between commit d9ebd04d3476 ("i2c: omap:
> switch to devm_* API") from the i2c-embedded tree and commit 07baca6f8fc2
> ("i2c/i2c-omap: add a const qualifier") from the arm-soc tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
looks correct.

Thanks
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
