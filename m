Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932088Ab1I1Wi6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:38:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53597 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755609Ab1I1Wiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:38:50 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:29 2011
Message-Id: <20110928220129.692666817@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:00:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>
Subject: [042/244] sparc64: Set HAVE_C_RECORDMCOUNT
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit 178a29600340bef5b13cd4157053679debe35351 ]

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/sparc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -53,6 +53,7 @@ config SPARC64
 	select HAVE_PERF_EVENTS
 	select PERF_USE_VMALLOC
 	select IRQ_PREFLOW_FASTEOI
+	select HAVE_C_RECORDMCOUNT
 
 config ARCH_DEFCONFIG
 	string


