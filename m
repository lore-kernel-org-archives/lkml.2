Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240Ab0CSPVy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 11:21:54 -0400
Received: from kroah.org ([198.145.64.141]:45919 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652Ab0CSPTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 11:19:04 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 10/12] kobject: documentation: Update to refer to kset-example.c.
Date: Fri, 19 Mar 2010 08:18:53 -0700
Message-Id: <1269011935-8886-10-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <20100319151311.GA8541@kroah.com>
References: <20100319151311.GA8541@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert P. J. Day <rpjday@crashcourse.ca>

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/kobject.txt |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/Documentation/kobject.txt b/Documentation/kobject.txt
index 668cb83..3ab2472 100644
--- a/Documentation/kobject.txt
+++ b/Documentation/kobject.txt
@@ -406,4 +406,5 @@ called, and the objects in the former circle release each other.
 Example code to copy from
 
 For a more complete example of using ksets and kobjects properly, see the
-sample/kobject/kset-example.c code.
+example programs samples/kobject/{kobject-example.c,kset-example.c},
+which will be built as loadable modules if you select CONFIG_SAMPLE_KOBJECT.
-- 
1.7.0.2

