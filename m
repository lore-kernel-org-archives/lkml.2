Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934483Ab0KQGlO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 01:41:14 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:57973 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933297Ab0KQGlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 01:41:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=Ua6sDUb3tIlAkQiRtZ97pQbqU27KceMi+a0vegaeJOp6DBc9Qu9GmhsvBDFTmTtzJN
         muYRmL4ypoyTa4p2/axHLMnE7rooLs5q2EvufxJ6Cxi5TrbFa8o5JyBkg+Y/9OuRQIPp
         Cyj5+ArZVDnAFlaFrJm3oucub2IUqp1/aXgfs=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Magnus Damm <magnus.damm@gmail.com>, lethal@linux-sh.org,
        g.liakhovetski@gmx.de, linux-sh@vger.kernel.org
Date: Wed, 17 Nov 2010 15:44:05 +0900
Message-Id: <20101117064405.18139.57035.sendpatchset@t400s>
Subject: [PATCH 00/05] fbdev: SH-Mobile MIPI-DSI Update
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fbdev: SH-Mobile MIPI-DSI Update

[PATCH 01/05] fbdev: sh_mipi_dsi: Remove request/release mem region
[PATCH 02/05] fbdev: sh_mipi_dsi: Make use of register names
[PATCH 03/05] ARM: mach-shmobile: Extend AP4EVB MIPI-DSI resources
[PATCH 04/05] fbdev: sh_mipi_dsi: Require two I/O resources
[PATCH 05/05] fbdev: sh_mipi_dsi: Allow LCDC board callbacks

These patches contain a few rather trivial updates for the
sh_mipi_dsi driver. Necessary changes to the AP4EVB specific
platform data is also included in [PATCH 03/05]. It should
be applied before [PATCH 04/05].

The patches above contain the following two major features:
- Support newer SoCs with different I/O base adresses
- Allow board-specific LCDC hooks together with MIPI-DSI

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 arch/arm/mach-shmobile/board-ap4evb.c |    7 +
 drivers/video/sh_mipi_dsi.c           |  131 ++++++++++++++++++++-------------
 2 files changed, 87 insertions(+), 51 deletions(-)
