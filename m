Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345Ab0D0PkG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 11:40:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13956 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755279Ab0D0PkC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 11:40:02 -0400
From: Adam Jackson <ajax@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] doc: Explain module parameter passing better
Date: Tue, 27 Apr 2010 11:40:00 -0400
Message-Id: <1272382800-19636-1-git-send-email-ajax@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We covered "passing with modprobe" and "builtins on kcmdline" but not
"modules on kcmdline".

Signed-off-by: Adam Jackson <ajax@redhat.com>
---
 Documentation/kernel-parameters.txt |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 5814331..9209ab4 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -6,14 +6,13 @@ The following is a consolidated list of the kernel parameters as implemented
 (defined as ignoring all punctuation and sorting digits before letters in a
 case insensitive manner), and with descriptions where known.
 
-Module parameters for loadable modules are specified only as the
-parameter name with optional '=' and value as appropriate, such as:
+Module parameters are passed to modprobe as the parameter name, with optional
+'=' and value if appropriate, such as:
 
 	modprobe usbcore blinkenlights=1
 
-Module parameters for modules that are built into the kernel image
-are specified on the kernel command line with the module name plus
-'.' plus parameter name, with '=' and value if appropriate, such as:
+Module parameters are passed on the kernel command line with the module
+name plus '.' plus parameter name, with '=' and value if appropriate, such as:
 
 	usbcore.blinkenlights=1
 
-- 
1.7.0.1

