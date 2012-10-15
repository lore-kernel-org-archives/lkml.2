Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab2JOBuQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 21:50:16 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:39900 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752988Ab2JOBuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 21:50:14 -0400
Message-ID: <507B6BCD.3040708@xenotime.net>
Date: Sun, 14 Oct 2012 18:50:05 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        David Howells <dhowells@redhat.com>
Subject: [PATCH] docbook: networking: fix file paths for uapi headers
References: <CA+55aFyt0KFNp5Binu-c3-XzF=MG+23EDOk1R6t4qqgW58ksAw@mail.gmail.com>
In-Reply-To: <CA+55aFyt0KFNp5Binu-c3-XzF=MG+23EDOk1R6t4qqgW58ksAw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Update file paths in Documentation/DocBook/networking.tmpl for uapi headers.

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 Documentation/DocBook/networking.tmpl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- lnx-37-rc1.orig/Documentation/DocBook/networking.tmpl
+++ lnx-37-rc1/Documentation/DocBook/networking.tmpl
@@ -56,7 +56,7 @@
 !Enet/core/filter.c
      </sect1>
      <sect1><title>Generic Network Statistics</title>
-!Iinclude/linux/gen_stats.h
+!Iinclude/uapi/linux/gen_stats.h
 !Enet/core/gen_stats.c
 !Enet/core/gen_estimator.c
      </sect1>
@@ -80,7 +80,7 @@
 !Enet/wimax/op-rfkill.c
 !Enet/wimax/stack.c
 !Iinclude/net/wimax.h
-!Iinclude/linux/wimax.h
+!Iinclude/uapi/linux/wimax.h
      </sect1>
   </chapter>
 
