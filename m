Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866Ab2K2GOl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 01:14:41 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:57631 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751406Ab2K2GOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 01:14:40 -0500
Message-ID: <1354169679.29762.28.camel@joe-AO722>
Subject: [PATCH] MAINTAINERS: TTY - Add linux-serial mailing list
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.cz>
Cc: Chen Gang <gang.chen@asianux.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org
Date: Wed, 28 Nov 2012 22:14:39 -0800
In-Reply-To: <50B6F967.3050000@asianux.com>
References: <50B6E751.9000000@asianux.com> <20121129051335.GA4375@kroah.com>
	 <50B6F967.3050000@asianux.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index afc0b27..255dafb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7658,6 +7658,7 @@ K:	^Subject:.*(?i)trivial
 TTY LAYER
 M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 M:	Jiri Slaby <jslaby@suse.cz>
+L:	linux-serial@vger.kernel.org
 S:	Supported
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
 F:	drivers/tty/


