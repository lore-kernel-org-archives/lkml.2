Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580Ab0HRPsB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 11:48:01 -0400
Received: from adelie.canonical.com ([91.189.90.139]:51950 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264Ab0HRPrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 11:47:15 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 16/16] checkpatch: version 0.31
Date: Wed, 18 Aug 2010 16:46:49 +0100
Message-Id: <1282146409-30544-17-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282146409-30544-1-git-send-email-apw@canonical.com>
References: <1282146409-30544-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index d086ffe..c1e7fb3 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -10,7 +10,7 @@ use strict;
 my $P = $0;
 $P =~ s@.*/@@g;
 
-my $V = '0.30';
+my $V = '0.31';
 
 use Getopt::Long qw(:config no_auto_abbrev);
 
-- 
1.7.0.4

