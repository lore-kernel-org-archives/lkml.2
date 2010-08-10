Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757620Ab0HJNKk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 09:10:40 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48340 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756410Ab0HJNKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 09:10:34 -0400
Date: Tue, 10 Aug 2010 15:10:32 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux kernel <linux-kernel@vger.kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Subject: dmaengine cyclic transfers
Message-ID: <20100810131032.GI27749@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 15:04:37 up 38 days,  4:15, 30 users,  load average: 0.26, 0.19,
	0.18
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I'm just looking into implementing the Freescale i.MX SDMA engine in the
dmaengine API. One usecase of this dma engine is sound. After some
digging I found the following commit:

commit d9de451989a88a2003ca06e524aca4665c0c7f06
Author: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Date:   Wed Apr 1 15:47:02 2009 +0200

    dw_dmac: add cyclic API to DW DMA driver

This could be very useful for the SDMA engine aswell. What are the
reasons this is not implemented in the generic dmaengine API but as
an extension to a specific driver? Should I also implement it like
this or isn't it better to extend the dmaengine itself?

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
