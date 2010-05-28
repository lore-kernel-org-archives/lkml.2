Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938Ab0E1IZ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 04:25:57 -0400
Received: from mail.gmx.net ([213.165.64.20]:40425 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754530Ab0E1IZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 04:25:55 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1+J/Yhl5MWJEQXuHhuYY2Zrd5FuDkllmpdrLGydiA
	cJ/hRPrM606Vde
From: Toralf Foerster <toralf.foerster@gmx.de>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] kconfig/streamline_config.pl: trivial typo
Date: Fri, 28 May 2010 10:25:52 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.34; KDE/4.4.3; i686; ; )
Cc: zippel@linux-m68k.org, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201005281025.52753.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Toralf Foerster <toralf.foerster@gmx.de>
---
 scripts/kconfig/streamline_config.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/kconfig/streamline_config.pl b/scripts/kconfig/streamline_config.pl
index 9726946..2f8bde8 100644
--- a/scripts/kconfig/streamline_config.pl
+++ b/scripts/kconfig/streamline_config.pl
@@ -242,7 +242,7 @@ foreach my $makefile (@makefiles) {
            foreach my $obj (split /\s+/,$objs) {
                $obj =~ s/-/_/g;
                if ($obj =~ /(.*)\.o$/) {
-                   # Objects may bes enabled by more than one config.
+                   # Objects may be enabled by more than one config.
                    # Store configs in an array.
                    my @arr;
 
-- 
1.6.4.4


-- 
MfG/Sincerely
Toralf Foerster

pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

