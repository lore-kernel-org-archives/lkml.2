Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560Ab0FMNL3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 09:11:29 -0400
Received: from hapkido.dreamhost.com ([66.33.216.122]:53572 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499Ab0FMNL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 09:11:28 -0400
Subject: [PATCH] README: Add build speed up tip in BUILD section.
From: Davidlohr Bueso <dave.bueso@gmail.com>
Reply-To: dave.bueso@gmail.com
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 13 Jun 2010 09:10:39 -0400
Message-ID: <1276434639.16577.6.camel@cowboy>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

IMHO the README file could benefit from GNU make's -j[N] option in BUILD section, as a general tip for users.

Not entirely sure who deals with this file, so sending to Linus.

Thanks.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 README |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/README b/README
index 737838f..fda7d52 100644
--- a/README
+++ b/README
@@ -154,6 +154,11 @@ BUILD directory for the kernel:
    Please note: If the 'O=output/dir' option is used then it must be
    used for all invocations of make.
 
+   Depending on the system and configuration, building the kernel can
+   take some time. To speed things up you can use GNU make's -j[N] option
+   to specify the number of jobs to run simultaneously. The N value should
+   be twice the amount of the machine's CPUs.  
+
 CONFIGURING the kernel:
 
    Do not skip this step even if you are only upgrading one minor
-- 
1.7.0.4



