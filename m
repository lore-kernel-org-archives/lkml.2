Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757Ab0KWLGT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 06:06:19 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:39485 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab0KWLGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 06:06:18 -0500
From: Jamie Iles <jamie@jamieiles.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] dmaengine/dw_dmac: enhancements to allow use on other platforms
Date: Tue, 23 Nov 2010 11:06:07 +0000
Message-Id: <1290510371-23077-1-git-send-email-jamie@jamieiles.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch series makes a couple of small changes to allow the dw_dmac driver
to be used on other platforms in addition to the current Atmel part. This
includes allowing controllers to be marked as private by the platform code and
to allow the source and destination AXI/AHB masters to be defined by the
platform.

Jamie Iles (4):
      dmaengine/dw_dmac: don't scan descriptors if no xfers in progress
      dmaengine/dw_dmac: allow src/dst masters to be configured at runtime
      dmaengine/dw_dmac: provide a mechanism to indicate private devices
      avr32: at32ap700x: specify DMA src and dst masters

 arch/avr32/mach-at32ap/at32ap700x.c |    6 +++++
 drivers/dma/dw_dmac.c               |   36 +++++++++++++++++++++-------------
 include/linux/dw_dmac.h             |    5 ++++
 3 files changed, 33 insertions(+), 14 deletions(-)

