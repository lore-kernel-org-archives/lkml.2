Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578Ab1GUHrh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 03:47:37 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61307 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab1GUHrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 03:47:35 -0400
Subject: [PATCH] HID: prodikeys: remove a redundant forward declaration of
 struct pcmidi_snd
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Don Prince <dhprince.devel@yahoo.co.uk>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Jul 2011 15:47:28 +0800
Message-ID: <1311234448.16867.0.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/hid/hid-prodikeys.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-prodikeys.c b/drivers/hid/hid-prodikeys.c
index ab19f29..53c9850 100644
--- a/drivers/hid/hid-prodikeys.c
+++ b/drivers/hid/hid-prodikeys.c
@@ -44,8 +44,6 @@ struct pk_device {
 	struct pcmidi_snd	*pm; /* pcmidi device context */
 };
 
-struct pcmidi_snd;
-
 struct pcmidi_sustain {
 	unsigned long		in_use;
 	struct pcmidi_snd	*pm;
-- 
1.7.4.1



