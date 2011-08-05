Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783Ab1HEVgv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 17:36:51 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:46270 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752166Ab1HEVgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 17:36:48 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+0y31MpYe0XwpGHSPkaUSJiZGGQiABDUdZPMDXF/
	3Rz+jF14hQEO4R
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 2/6] viafb: kill viafb_load_crtc_timing
Date: Fri,  5 Aug 2011 21:55:17 +0000
Message-Id: <f18e3e0ce0dacca497e3f1547095b3f9b111b0f7.1312578946.git.FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <cover.1312578946.git.FlorianSchandinat@gmx.de>
References: <cover.1312578946.git.FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces calls to viafb_load_crtc_timing with the code.
This should make it easier to fix the oddity that in the modetable
the blank and sync end entries contain the length and we need to add
the start values to get those to be written to the hardware.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

 drivers/video/via/hw.c  |   30 ++++++++----------------------
 drivers/video/via/lcd.c |   41 +++++++++++++++++++----------------------
 drivers/video/via/lcd.h |    2 --
 3 files changed, 27 insertions(+), 46 deletions(-)
-- 
1.6.3.2

