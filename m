Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314Ab2JBVN1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 17:13:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932172Ab2JBVNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 17:13:25 -0400
Date: Tue, 2 Oct 2012 17:13:20 -0400
From: Dave Jones <davej@redhat.com>
To: davem@davemloft.net
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Build SPARC DES algorithms on SPARC only.
Message-ID: <20121002211320.GA23777@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, davem@davemloft.net,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Asking for this option on x86 seems a bit pointless.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 94f232f..957cc56 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -796,6 +796,7 @@ config CRYPTO_DES
 
 config CRYPTO_DES_SPARC64
 	tristate "DES and Triple DES EDE cipher algorithms (SPARC64)"
+	depends on SPARC64
 	select CRYPTO_ALGAPI
 	select CRYPTO_DES
 	help
