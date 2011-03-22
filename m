Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250Ab1CVUay (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 16:30:54 -0400
Received: from tex.lwn.net ([70.33.254.29]:60221 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755158Ab1CVUat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 16:30:49 -0400
Date: Tue, 22 Mar 2011 14:30:47 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Greg KH <greg@kroah.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH] docs: Fix dev_debug in dynamic-debug-howto.txt
Message-ID: <20110322143047.43f90986@bike.lwn.net>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.3; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While looking at dynamic-debug-howto.txt, I noticed that it references
dev_debug() (which doesn't exist) instead of dev_dbg() (which does
exist).  I'm lazy, so I choose to fix the document rather than changing
every dev_dbg() call.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>

diff --git a/Documentation/dynamic-debug-howto.txt b/Documentation/dynamic-debug-howto.txt
index e6c4b75..f959909 100644
--- a/Documentation/dynamic-debug-howto.txt
+++ b/Documentation/dynamic-debug-howto.txt
@@ -6,7 +6,7 @@ This document describes how to use the dynamic debug (ddebug) feature.
 
 Dynamic debug is designed to allow you to dynamically enable/disable kernel
 code to obtain additional kernel information. Currently, if
-CONFIG_DYNAMIC_DEBUG is set, then all pr_debug()/dev_debug() calls can be
+CONFIG_DYNAMIC_DEBUG is set, then all pr_debug()/dev_dbg() calls can be
 dynamically enabled per-callsite.
 
 Dynamic debug has even more useful features:
@@ -26,7 +26,7 @@ Dynamic debug has even more useful features:
 Controlling dynamic debug Behaviour
 ===================================
 
-The behaviour of pr_debug()/dev_debug()s are controlled via writing to a
+The behaviour of pr_debug()/dev_dbg()s are controlled via writing to a
 control file in the 'debugfs' filesystem. Thus, you must first mount the debugfs
 filesystem, in order to make use of this feature. Subsequently, we refer to the
 control file as: <debugfs>/dynamic_debug/control. For example, if you want to
