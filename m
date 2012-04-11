Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759727Ab2DKLy4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 07:54:56 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:58952 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757202Ab2DKLyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 07:54:54 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: plagnioj@jcrosoft.com, Josh.wu@atmel.com,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 0/5] ARM: at91: update MAINTAINERS entries
Date: Wed, 11 Apr 2012 13:54:41 +0200
Message-Id: <cover.1334137680.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.9.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some additions to the MAINTAINERS file regarding AT91 related drivers.
Josh and I are adding entries for drivers that we have been taking care of
since quite some time.

Patches on top of 3.4-rc2.

Josh Wu (2):
  MAINTAINERS: add entry for Atmel isi driver
  MAINTAINERS: add entry for Atmel touch screen ADC controller driver

Nicolas Ferre (3):
  MAINTAINERS: add entry for Atmel DMA driver
  MAINTAINERS: add entry for Atmel timer counter (TC)
  MAINTAINERS: remove non-responding web link for atmel_usba driver

 MAINTAINERS |   29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

Best regards,
-- 
1.7.9.4

