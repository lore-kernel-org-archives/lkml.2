Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031760Ab2CIUDH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 15:03:07 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64616 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031695Ab2CITxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:53:00 -0500
Message-Id: <20120309190218.018541129@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:02:52 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Fabio Baltieri <fabio.baltieri@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: [ 38/68] avr32: select generic atomic64_t support
In-Reply-To: <20120309194409.GA2069@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Baltieri <fabio.baltieri@gmail.com>

commit 31e0017e6f6fb5cfdfaf932c1f98c9bef8d57688 upstream.

Enable use of the generic atomic64 implementation on AVR32 platforms.
Without this the kernel fails to build as the architecture does not
provide its version.

Signed-off-by: Fabio Baltieri <fabio.baltieri@gmail.com>
Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/avr32/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/avr32/Kconfig
+++ b/arch/avr32/Kconfig
@@ -8,6 +8,7 @@ config AVR32
 	select HAVE_KPROBES
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_PROBE
+	select GENERIC_ATOMIC64
 	select HARDIRQS_SW_RESEND
 	select GENERIC_IRQ_SHOW
 	help


