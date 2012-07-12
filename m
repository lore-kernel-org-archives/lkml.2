Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933951Ab2GLUzs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 16:55:48 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:3840 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932923Ab2GLUzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 16:55:47 -0400
Message-ID: <1342126544.22584.36.camel@x61.thuisdomein>
Subject: SPI: bcm63xx_dev_spi.h
From: Paul Bolle <pebolle@tiscali.nl>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Date: Thu, 12 Jul 2012 22:55:44 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 12 Jul 2012 20:55:45.0648 (UTC) FILETIME=[B536BF00:01CD6070]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

0) Commit b42dfed83d95a3c9e9cbd708f1993a7474abb79a ("spi: add Broadcom
BCM63xx SPI controller driver") added drivers/spi/spi-bcm63xx.c to the
mainline tree. That file includes bcm63xx_dev_spi.h.

1) bcm63xx_dev_spi.h is not part of the current tree, and, as far as I
can tell, has actually never been part of the tree. So it seems that
this driver could never be built using the mainline tree since it got
added (in v3.4).

2) What's the current status of this header?


Paul Bolle

