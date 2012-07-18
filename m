Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757763Ab2GRAHj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 20:07:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37684 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757572Ab2GRAFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 20:05:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Samuel Ortiz <sameo@linux.intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 37/37] NFC: Export nfc.h to userland
Date: Tue, 17 Jul 2012 17:03:14 -0700
Message-Id: <20120717232434.529756095@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120717232431.399005532@linuxfoundation.org>
References: <20120717232455.GA5994@kroah.com>
 <20120717232431.399005532@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Ortiz <sameo@linux.intel.com>

commit dbd4fcaf8d664fab4163b1f8682e41ad8bff3444 upstream.

The netlink commands and attributes, along with the socket structure
definitions need to be exported.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/Kbuild |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -272,6 +272,7 @@ header-y += netfilter_ipv4.h
 header-y += netfilter_ipv6.h
 header-y += netlink.h
 header-y += netrom.h
+header-y += nfc.h
 header-y += nfs.h
 header-y += nfs2.h
 header-y += nfs3.h


