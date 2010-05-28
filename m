Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932669Ab0E1Or5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 10:47:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:33944 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758336Ab0E1Orv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 10:47:51 -0400
X-Authority-Analysis: v=1.1 cv=WC2cwRI/KXdLNEmE8ivg2cmI8vFt6dWmaZdvaJ93QHU= c=1 sm=0 a=-TyaHEymc8kA:10 a=Lw_SFsgOoS4A:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=meVymXHHAAAA:8 a=j6Hn53hOalJE8Rg62-sA:9 a=83YuAiujeDqjHWw5IAmIFfd-vvAA:4 a=_RhRFcbxBZMA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100528144749.296636799@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 28 May 2010 10:43:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kbuild@vger.kernel.org,
       Toralf Foerster <toralf.foerster@gmx.de>
Subject: [PATCH 2/3] [PATCH 2/3] kconfig: Fix typo in comment in streamline_config.pl
References: <20100528144323.232583082@goodmis.org>
Content-Disposition: inline; filename=0002-kconfig-Fix-typo-in-comment-in-streamline_config.pl.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Toralf Foerster <toralf.foerster@gmx.de>

Signed-off-by: Toralf Foerster <toralf.foerster@gmx.de>
LKML-Reference: <201005281025.52753.toralf.foerster@gmx.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
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
-		    # Objects may bes enabled by more than one config.
+		    # Objects may be enabled by more than one config.
 		    # Store configs in an array.
 		    my @arr;
 
-- 
1.7.0


