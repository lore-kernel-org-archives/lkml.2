Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934098Ab1KJDWp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:22:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41847 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934021Ab1KJDWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:22:40 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:06 2011
Message-Id: <20111109212706.064784749@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:26:19 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, stable@kernel.org, netdev@vger.kernel.org,
        jouni@qca.qualcomm.com, yangjie@qca.qualcomm.com,
        vthiagar@qca.qualcomm.com, senthilb@qca.qualcomm.com,
        "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [057/262] MAINTANERS: update Qualcomm Atheros addresses
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>

commit fe8e084455f273b32cc57a5fbaf6c22ef984d657 upstream.

Qualcomm ate up Atheros, all of the old e-mail addresses
no longer work and e-mails sent to it will bounce. Update
the addresses to the new shiny Qualcomm Atheros (QCA) ones.

Cc: stable@kernel.org
Cc: netdev@vger.kernel.org
Cc: jouni@qca.qualcomm.com
Cc: yangjie@qca.qualcomm.com
Cc: vthiagar@qca.qualcomm.com
Cc: senthilb@qca.qualcomm.com
Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 MAINTAINERS |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1221,7 +1221,7 @@ F:	Documentation/aoe/
 F:	drivers/block/aoe/
 
 ATHEROS ATH GENERIC UTILITIES
-M:	"Luis R. Rodriguez" <lrodriguez@atheros.com>
+M:	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
 L:	linux-wireless@vger.kernel.org
 S:	Supported
 F:	drivers/net/wireless/ath/*
@@ -1229,7 +1229,7 @@ F:	drivers/net/wireless/ath/*
 ATHEROS ATH5K WIRELESS DRIVER
 M:	Jiri Slaby <jirislaby@gmail.com>
 M:	Nick Kossifidis <mickflemm@gmail.com>
-M:	"Luis R. Rodriguez" <lrodriguez@atheros.com>
+M:	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
 M:	Bob Copeland <me@bobcopeland.com>
 L:	linux-wireless@vger.kernel.org
 L:	ath5k-devel@lists.ath5k.org
@@ -1238,10 +1238,10 @@ S:	Maintained
 F:	drivers/net/wireless/ath/ath5k/
 
 ATHEROS ATH9K WIRELESS DRIVER
-M:	"Luis R. Rodriguez" <lrodriguez@atheros.com>
-M:	Jouni Malinen <jmalinen@atheros.com>
-M:	Vasanthakumar Thiagarajan <vasanth@atheros.com>
-M:	Senthil Balasubramanian <senthilkumar@atheros.com>
+M:	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
+M:	Jouni Malinen <jouni@qca.qualcomm.com>
+M:	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
+M:	Senthil Balasubramanian <senthilb@qca.qualcomm.com>
 L:	linux-wireless@vger.kernel.org
 L:	ath9k-devel@lists.ath9k.org
 W:	http://wireless.kernel.org/en/users/Drivers/ath9k
@@ -1269,7 +1269,7 @@ F:	drivers/input/misc/ati_remote2.c
 ATLX ETHERNET DRIVERS
 M:	Jay Cliburn <jcliburn@gmail.com>
 M:	Chris Snook <chris.snook@gmail.com>
-M:	Jie Yang <jie.yang@atheros.com>
+M:	Jie Yang <yangjie@qca.qualcomm.com>
 L:	netdev@vger.kernel.org
 W:	http://sourceforge.net/projects/atl1
 W:	http://atl1.sourceforge.net


