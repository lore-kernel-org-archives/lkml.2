Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab0LIQmT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 11:42:19 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35378 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754269Ab0LIQlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 11:41:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Iq4v6YajqkPJsZwdR4XLVNC42TBMvcAHBmQtBa81dz9ODu2aFCLz6cw67VItire4oE
         +/aJSORZ2iUHXaMNiL1YClgA74tzTIiH5RU+fDZ/zxgCC0Bd7ePW2MO+KIkW7HgGZK+c
         9C7xjwY1XesdgGP8NpopUL+7QA0jqUXvdlEZM=
From: Namhyung Kim <namhyung@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] Staging: cx25821: use DEFINE_PCI_DEVICE_TABLE
Date: Fri, 10 Dec 2010 01:40:26 +0900
Message-Id: <1291912830-13151-3-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.3.3.400.g93cef
In-Reply-To: <1291912830-13151-1-git-send-email-namhyung@gmail.com>
References: <1291912830-13151-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert 'const struct pci_device_id xxx[]' to 'DEFINE_PCI_DEVICE_TABLE(xxx)'.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 drivers/staging/cx25821/cx25821-alsa.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-alsa.c b/drivers/staging/cx25821/cx25821-alsa.c
index 2a01dc057b2c..1f2e819c4320 100644
--- a/drivers/staging/cx25821/cx25821-alsa.c
+++ b/drivers/staging/cx25821/cx25821-alsa.c
@@ -629,7 +629,7 @@ static int snd_cx25821_pcm(struct cx25821_audio_dev *chip, int device,
  * Only boards with eeprom and byte 1 at eeprom=1 have it
  */
 
-static const struct pci_device_id cx25821_audio_pci_tbl[] __devinitdata = {
+static DEFINE_PCI_DEVICE_TABLE(cx25821_audio_pci_tbl) = {
 	{0x14f1, 0x0920, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{0,}
 };
-- 
1.7.3.3.400.g93cef

