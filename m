Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675Ab1AUOMN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 09:12:13 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:63006 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487Ab1AUOMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 09:12:12 -0500
From: Jamie Iles <jamie@jamieiles.com>
To: linux-kernel@vger.kernel.org
Cc: Jamie Iles <jamie@jamieiles.com>
Subject: [PATCH repost 0/4] dmaengine/dw_dmac: enhancements to allow use
Date: Fri, 21 Jan 2011 14:11:51 +0000
Message-Id: <1295619115-18420-1-git-send-email-jamie@jamieiles.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a repost of the patch series previously posted back in November
last year to allow the DW_DMAC driver to be used on architectures other
than AV32 (there is still a dependency on AVR32 but I'll create a follow
up patch for this once we have a user in tree).

Jamie Iles (4):
  dmaengine/dw_dmac: don't scan descriptors if no xfers in progress
  dmaengine/dw_dmac: allow src/dst masters to be configured at runtime
  dmaengine/dw_dmac: provide a mechanism to indicate private devices
  avr32: at32ap700x: specify DMA src and dst masters

 arch/avr32/mach-at32ap/at32ap700x.c |    6 +++++
 drivers/dma/dw_dmac.c               |   36 +++++++++++++++++++++-------------
 include/linux/dw_dmac.h             |    5 ++++
 3 files changed, 33 insertions(+), 14 deletions(-)

-- 
1.7.3.4

