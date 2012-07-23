Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790Ab2GWBvd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 21:51:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54384 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753482Ab2GWBnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 21:43:24 -0400
Message-Id: <20120723010658.737029738@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 23 Jul 2012 02:07:39 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Samuel Ortiz <sameo@linux.intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 048/108] NFC: Export nfc.h to userland
In-Reply-To: <20120723010651.408577075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Ortiz <sameo@linux.intel.com>

commit dbd4fcaf8d664fab4163b1f8682e41ad8bff3444 upstream.

The netlink commands and attributes, along with the socket structure
definitions need to be exported.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/Kbuild |    1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 3c9b616..f08e3ae 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -271,6 +271,7 @@ header-y += netfilter_ipv4.h
 header-y += netfilter_ipv6.h
 header-y += netlink.h
 header-y += netrom.h
+header-y += nfc.h
 header-y += nfs.h
 header-y += nfs2.h
 header-y += nfs3.h


