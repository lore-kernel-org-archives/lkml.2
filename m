Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601Ab0HPLH6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 07:07:58 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58956 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab0HPLH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 07:07:56 -0400
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.ml.walleij@gmail.com>,
        Dan Williams <dan.j.williams@intel.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [RFC] dmaengine: assorted patches and Freescale SDMA support
Date: Mon, 16 Aug 2010 13:07:47 +0200
Message-Id: <1281956870-12463-1-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.1
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This is the first attempt to implement the Freescale i.MX SDMA engine
as part of the dmaengine API.

The first patch adds support for cyclic transfers usable for audio. There
is a similar approach implemented for the dw_dmac, this patch instead adds
the cyclic transfers to the dmaengine API.

Other patches not posted here are necessary to actually make use of the
SDMA engine. Please pull the following branch if you want to test these
patches. The branch includes mxcmmc support for the i.MX31 based on SDMA
and i.MX35-3stack audio support (sgtl5000 codec):

http://git.pengutronix.de/git/imx/linux-2.6.git sdma-sdmaengine

For generating firmware images for the SDMA engine look at

http://git.pengutronix.de/git/imx/sdma-firmware.git

Sascha

