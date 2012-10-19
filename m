Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097Ab2JSHGa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 03:06:30 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:55185 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756871Ab2JSHG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 03:06:26 -0400
From: AnilKumar Ch <anilkumar@ti.com>
To: <dmitry.torokhov@gmail.com>, <grant.likely@secretlab.ca>
CC: <rob.herring@calxeda.com>, <dgdunix@gmail.com>,
        <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, AnilKumar Ch <anilkumar@ti.com>
Subject: [PATCH 0/2] Input: matrix-keypad - Add device tree support
Date: Fri, 19 Oct 2012 12:36:11 +0530
Message-ID: <1350630373-24279-1-git-send-email-anilkumar@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree support to matrix keypad driver by adding all necessary
DT parameters. Also added device tree bindings.

These patches were tested on AM335x-EVM with DT patches, DT patches
will be submitted once these are accepted.

AnilKumar Ch (2):
  Input: matrix-keypad - remove const from pointer to array of gpios
  Input: matrix-keypad - Add device tree support

 .../devicetree/bindings/input/matrix-keypad.txt    |   52 ++++++++++
 drivers/input/keyboard/matrix_keypad.c             |  104 +++++++++++++++++++-
 include/linux/input/matrix_keypad.h                |    4 +-
 3 files changed, 157 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/input/matrix-keypad.txt

-- 
1.7.9.5

