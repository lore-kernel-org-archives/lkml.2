Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767Ab2JPPwg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 11:52:36 -0400
Received: from alvesta.synopsys.com ([198.182.60.77]:63618 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754336Ab2JPPwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 11:52:35 -0400
X-Greylist: delayed 419 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Oct 2012 11:52:35 EDT
From: Mischa Jonker <mischa.jonker@synopsys.com>
To: dmitry.torokhov@gmail.com, m.d.s.x.jonker@gmail.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Mischa Jonker <mischa.jonker@synopsys.com>
Subject: [PATCH] RFC: ARC PS/2 driver
Date: Tue, 16 Oct 2012 17:44:57 +0200
Message-Id: <1350402298-12890-1-git-send-email-mischa.jonker@synopsys.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the ARC PS/2 block which is used in various
ARC FPGA platforms. It has been tested on the ARC Angel 4 platform and the
nSIM OSCI virtual model.

Mischa Jonker (1):
  Input: serio - Add ARC PS/2 driver

 drivers/input/serio/Kconfig   |    9 ++
 drivers/input/serio/Makefile  |    1 +
 drivers/input/serio/arc_ps2.c |  287 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 297 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/serio/arc_ps2.c

