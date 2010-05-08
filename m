Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776Ab0EHVjy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 17:39:54 -0400
Received: from ist.d-labs.de ([213.239.218.44]:51473 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753131Ab0EHVjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 17:39:52 -0400
From: florian@mickler.org
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Hemminger <shemminger@vyatta.com>, linux-kernel@vger.kernel.org,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Florian Mickler <florian@mickler.org>
Subject: [PATCH] [RFC] get_maintainer.pl: only list maintainers by default
Date: Sat,  8 May 2010 23:39:38 +0200
Message-Id: <1273354778-6129-1-git-send-email-florian@mickler.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1273354364-6016-1-git-send-email-florian@mickler.org>
References: <1273354364-6016-1-git-send-email-florian@mickler.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If scm meta-information is used, only list people that signed-off or
acked or reviewed the code in question.

after all it's called get_maintainer.pl and not
get_random_people_to_look_at_the_code.pl

Signed-off-by: Florian Mickler <florian@mickler.org>
---
 scripts/get_maintainer.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index 8e974bb..2c53476 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -25,7 +25,7 @@ my $email_list = 1;
 my $email_subscriber_list = 0;
 my $email_git_penguin_chiefs = 0;
 my $email_git = 1;
-my $email_git_maintainers = 0;
+my $email_git_maintainers = 1;
 my $email_git_blame = 0;
 my $email_git_min_signatures = 1;
 my $email_git_max_maintainers = 5;
-- 
1.7.0.4

