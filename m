Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762372Ab0GUFGu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:06:50 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49232 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762280Ab0GUE6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:58:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ItsFRC9t15gwCF8IoZ5GQ1ZOq1W7bBzr6fGdzSzfKoRlUTgF6vhvCLJSb3TFMyMdgV
         HfaXAI2zRJKdKabptl0ROqcknLcJnzfGwFtBCwdL8p3eyhqBefEF4QN1aKk5O4bOp+9P
         hoKfz025djwibv/PbU3EF5+jkYM5I5P1PDBpM=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 112/112]Documentation/sound/alsa/soc/DAI.txt update web address.
Date: Tue, 20 Jul 2010 21:57:51 -0700
Message-Id: <1279688279-29683-7-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688279-29683-1-git-send-email-justinmattock@gmail.com>
References: <1279688279-29683-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates a broken web address.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/sound/alsa/soc/DAI.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/sound/alsa/soc/DAI.txt b/Documentation/sound/alsa/soc/DAI.txt
index 0ebd7ea..c967926 100644
--- a/Documentation/sound/alsa/soc/DAI.txt
+++ b/Documentation/sound/alsa/soc/DAI.txt
@@ -13,7 +13,7 @@ frame (FRAME) (usually 48kHz) is always driven by the controller. Each AC97
 frame is 21uS long and is divided into 13 time slots.
 
 The AC97 specification can be found at :-
-http://www.intel.com/design/chipsets/audio/ac97_r23.pdf
+http://www.intel.com/p/en_US/business/design
 
 
 I2S
-- 
1.7.1.rc1.21.gf3bd6

