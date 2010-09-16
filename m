Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184Ab0IPUTn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 16:19:43 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34776 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037Ab0IPUTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 16:19:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=DtMs33nHFko4z8s/5ITBWVqa3ScG6amabnB5gG5GCSD45pPE4sYJEcpOCqcJz9m4eW
         Id6trChtWB/ostwiS8piVKqdldjt/rd04dX52EMZuttA9VAEGa5gcohcGmD39r6H/rVu
         1q8Qn0vI2geb5kZbWEGAZS/ycvZ/MotrOfXDM=
From: wellsk40@gmail.com
To: linus.walleij@stericsson.com, grant.likely@secretlab.ca,
        spi-devel-general@lists.sourceforge.net
Cc: sameo@linux.intel.com, rabin.vincent@stericsson.com,
        srinidhi.kasagar@stericsson.com, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, u.kleine-koenig@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, tj@kernel.org
Subject: spi: amba_pl022: driver and platform spi->mode fixes
Date: Thu, 16 Sep 2010 06:18:49 -0700
Message-Id: <1284643130-17659-1-git-send-email-wellsk40@gmail.com>
X-Mailer: git-send-email 1.7.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is a merge of the previously posted and reviewed
patch series:
	amba_pl022: Setup SPI configuration based on spi->mode
	amba_pl022 spi->mode fix/cleanup patches

It also fixes an incorrect bit assignment for SPHA mode.

This patch can be pulled from:
	git pull git://git.lpclinux.com/linux-2.6-lpc amba_pl022_spimode

