Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529Ab0LARh7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 12:37:59 -0500
Received: from mail.perches.com ([173.55.12.10]:2060 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753340Ab0LARh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 12:37:57 -0500
Subject: [PATCH wireless-next] MAINTAINERS: Add ATH GENERIC UTILITIES
From: Joe Perches <joe@perches.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "John W. Linville" <linville@tuxdriver.com>
Cc: Felix Fietkau <nbd@openwrt.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        ath9k-devel@venema.h4ckr.net, peter@stuge.se,
        linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTik2qtGUgkZYSjcEH9jHHsevKnxOvz4s6On94U9o@mail.gmail.com>
References: <5febb0e1fba0ec2bb77f6ade8b251ba0edf4614c.1290988277.git.joe@perches.com>
	 <AANLkTinc251WbwuLqFbOZ5ipNGZW7=wub3DoWwy42=+e@mail.gmail.com>
	 <20101129060732.5130.qmail@stuge.se> <4CF42C17.2070500@openwrt.org>
	 <1291081185.16349.133.camel@Joe-Laptop> <4CF464D6.2020507@openwrt.org>
	 <1291148375.18026.342.camel@Joe-Laptop>
	 <AANLkTik2qtGUgkZYSjcEH9jHHsevKnxOvz4s6On94U9o@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Dec 2010 09:37:55 -0800
Message-ID: <1291225075.1845.177.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This file pattern is not currently shown as maintained
by atheros.  Perhaps it should be?

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b162fbb..b744d08 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1080,6 +1080,12 @@ S:	Supported
 F:	Documentation/aoe/
 F:	drivers/block/aoe/
 
+ATHEROS ATH GENERIC UTILITIES
+M:	"Luis R. Rodriguez" <lrodriguez@atheros.com>
+L:	linux-wireless@vger.kernel.org
+S:	Supported
+F:	drivers/net/wireless/ath/*
+
 ATHEROS ATH5K WIRELESS DRIVER
 M:	Jiri Slaby <jirislaby@gmail.com>
 M:	Nick Kossifidis <mickflemm@gmail.com>


